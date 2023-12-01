CREATE OR REPLACE FUNCTION trouver_variation_proche(column_value IN VARCHAR2, search_string IN VARCHAR2, seuil_similarity IN NUMBER)
RETURN VARCHAR2
IS
    word VARCHAR2(100);
    position INTEGER := 1;
    next_space INTEGER;
    closest_word VARCHAR2(100);
    min_distance NUMBER := 32767; -- Valeur maximale pour la distance d'édition
BEGIN
    LOOP
        next_space := INSTR(column_value, ' ', position);

        -- Extraire le mot
        IF next_space != 0 THEN
            word := SUBSTR(column_value, position, next_space - position);
        ELSE
            word := SUBSTR(column_value, position);
        END IF;

        -- Vérifier la distance d'édition
        IF UTL_MATCH.EDIT_DISTANCE(UPPER(word), UPPER(search_string)) <= seuil_similarity THEN
            IF UTL_MATCH.EDIT_DISTANCE(UPPER(word), UPPER(search_string)) < min_distance THEN
                min_distance := UTL_MATCH.EDIT_DISTANCE(UPPER(word), UPPER(search_string));
                closest_word := word;
            END IF;
        END IF;

        -- Préparer la position pour le prochain mot
        position := next_space + 1;

        -- Sortir de la boucle si la fin de la chaîne est atteinte
        EXIT WHEN next_space = 0 OR next_space IS NULL;
    END LOOP;

    RETURN closest_word;
END trouver_variation_proche;

----------------------------------
-- les lignes proches
CREATE OR REPLACE PROCEDURE rechercher_lignes_proches(table_name IN VARCHAR2, column_name IN VARCHAR2, search_string IN VARCHAR2, seuil_similarity IN NUMBER)
IS
    type t_cursor is ref cursor;
    c t_cursor;
    query_str VARCHAR2(1000);
    column_value VARCHAR2(4000);
BEGIN
    query_str := 'SELECT ' || column_name || ' FROM ' || table_name;
    
    OPEN c FOR query_str;
    LOOP
        FETCH c INTO column_value;
        EXIT WHEN c%NOTFOUND;

        IF trouver_variation_proche(column_value, search_string, seuil_similarity) IS NOT NULL THEN
            -- Afficher la valeur de la colonne ou la traiter selon vos besoins
            DBMS_OUTPUT.PUT_LINE(column_value);
        END IF;
    END LOOP;
    CLOSE c;
END rechercher_lignes_proches;


----------------------------------
BEGIN
    rechercher_lignes_proches('SOUSSOUSDomaineFormation', 'MotsCles', 'BI', 2);
END;