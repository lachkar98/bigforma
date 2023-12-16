CREATE OR REPLACE FUNCTION trouver_ligne_avec_mot_similaire(
    column_value IN VARCHAR2, 
    search_string IN VARCHAR2
) RETURN INTEGER
IS
    word VARCHAR2(100);
    position INTEGER := 1;
    next_space INTEGER;
    similarity_threshold INTEGER := 75; -- Seuil de similarité pour Jaro-Winkler
    levenshtein_threshold INTEGER := 1; -- Seuil pour la distance de Levenshtein pour les mots courts
    highest_similarity INTEGER := 0; -- Plus haut score de similarité trouvé
    current_similarity INTEGER;
    levenshtein_distance INTEGER;
BEGIN
    LOOP
        next_space := INSTR(column_value, ' ', position);
        IF next_space != 0 THEN
            word := SUBSTR(column_value, position, next_space - position);
        ELSE
            word := SUBSTR(column_value, position);
        END IF;

        IF LENGTH(search_string) <= 3 THEN
            levenshtein_distance := UTL_MATCH.EDIT_DISTANCE(UPPER(word), UPPER(search_string));
            IF levenshtein_distance <= levenshtein_threshold THEN
                current_similarity := 100; -- Score maximal pour une correspondance exacte
            END IF;
        ELSE
            current_similarity := UTL_MATCH.JARO_WINKLER_SIMILARITY(UPPER(word), UPPER(search_string));
        END IF;

        IF current_similarity > highest_similarity THEN
            highest_similarity := current_similarity;
        END IF;

        position := next_space + 1;
        EXIT WHEN next_space = 0 OR next_space IS NULL;
    END LOOP;

    IF highest_similarity >= similarity_threshold THEN
        RETURN highest_similarity;
    ELSE
        RETURN NULL;
    END IF;
END trouver_ligne_avec_mot_similaire;
/

drop table temp_resultats;
CREATE GLOBAL TEMPORARY TABLE temp_resultats (
    le_nom VARCHAR2(4000),
    score INTEGER
) ON COMMIT DELETE ROWS;

CREATE OR REPLACE FUNCTION trouver_lignes_avec_mots_similaires(
    search_string IN VARCHAR2
) RETURN VARCHAR2
IS
    result_lines VARCHAR2(32767);
    column_value_motscles VARCHAR2(4000);
    column_value_le_nom VARCHAR2(4000);
    current_score INTEGER;
BEGIN
    -- Nettoyer la table temporaire au début
    DELETE FROM temp_resultats;

    -- Logique pour calculer les scores et stocker les résultats dans la table temporaire
    FOR rec IN (SELECT motscles, LE_NOM FROM soussousdomaineformation)
    LOOP
        column_value_motscles := rec.motscles;
        column_value_le_nom := rec.LE_NOM;
        current_score := trouver_ligne_avec_mot_similaire(column_value_motscles, search_string);

        IF current_score IS NOT NULL THEN
            INSERT INTO temp_resultats (le_nom, score)
            VALUES (column_value_le_nom, current_score);
        END IF;
    END LOOP;

    -- Sélectionner et trier les résultats à partir de la table temporaire
    FOR rec IN (SELECT le_nom, score FROM temp_resultats ORDER BY score DESC)
    LOOP
        result_lines := result_lines || rec.le_nom || ' (Score: ' || rec.score || '); ';
    END LOOP;

    RETURN result_lines;
END trouver_lignes_avec_mots_similaires;
/
