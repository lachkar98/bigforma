CREATE OR REPLACE FUNCTION trouver_variation_proche(column_value IN VARCHAR2, search_string IN VARCHAR2)
RETURN VARCHAR2
IS
    word VARCHAR2(100);
    position INTEGER := 1;
    next_space INTEGER;
    closest_word VARCHAR2(100);
    min_distance NUMBER := 32767; -- Valeur maximale pour la distance d'édition
    search_length INTEGER;
    seuil_similarity INTEGER;
BEGIN
    -- Calculer une distance d'édition optimale basée sur la longueur de search_string
    search_length := LENGTH(search_string);
    seuil_similarity := ROUND(search_length / 4); -- Exemple : 1/4 de la longueur

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
/

----------------------------------
-- les lignes proches
CREATE OR REPLACE PROCEDURE rechercher_lignes_proches(table_name IN VARCHAR2, column_name IN VARCHAR2, search_string IN VARCHAR2)
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

        IF trouver_variation_proche(column_value, search_string) IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE(column_value);
        END IF;
    END LOOP;
    CLOSE c;
END rechercher_lignes_proches;
/
CREATE OR REPLACE FUNCTION search_phrase_OR(table_name IN VARCHAR2, column_name IN VARCHAR2, search_string IN VARCHAR2)
RETURN SYS_REFCURSOR
IS
    c SYS_REFCURSOR;
    query_str VARCHAR2(4000);
    word VARCHAR2(100);
    position INTEGER := 1;
    next_space INTEGER;
BEGIN
    query_str := 'SELECT DISTINCT TO_CHAR(DBMS_LOB.SUBSTR(' || column_name || ', 4000, 1)) FROM ' || table_name || ' WHERE ';

    LOOP
        next_space := INSTR(search_string, ' ', position);
        IF next_space != 0 THEN
            word := SUBSTR(search_string, position, next_space - position);
        ELSE
            word := SUBSTR(search_string, position);
        END IF;

        query_str := query_str || 'TO_CHAR(DBMS_LOB.SUBSTR(' || column_name || ', 4000, 1)) LIKE ''%' || word || '%''';
        
        position := next_space + 1;
        IF next_space != 0 THEN
            query_str := query_str || ' OR ';
        END IF;

        EXIT WHEN next_space = 0 OR next_space IS NULL;
    END LOOP;

    OPEN c FOR query_str;
    RETURN c;
END search_phrase_OR;
/

CREATE OR REPLACE FUNCTION search_phrase(table_name IN VARCHAR2, column_name IN VARCHAR2, search_string IN VARCHAR2)
RETURN SYS_REFCURSOR
IS
    c SYS_REFCURSOR;
    query_str VARCHAR2(4000);
    word VARCHAR2(100);
    position INTEGER := 1;
    next_space INTEGER;
    first_word BOOLEAN := TRUE;
BEGIN
    query_str := 'SELECT DISTINCT TO_CHAR(DBMS_LOB.SUBSTR(' || column_name || ', 4000, 1)) FROM ' || table_name || ' WHERE ';

    LOOP
        next_space := INSTR(search_string, ' ', position);
        IF next_space != 0 THEN
            word := SUBSTR(search_string, position, next_space - position);
        ELSE
            word := SUBSTR(search_string, position);
        END IF;

        IF NOT first_word THEN
            query_str := query_str || ' AND ';
        END IF;

        query_str := query_str || 'TO_CHAR(DBMS_LOB.SUBSTR(' || column_name || ', 4000, 1)) LIKE ''%' || word || '%''';
        
        position := next_space + 1;

        first_word := FALSE;

        EXIT WHEN next_space = 0 OR next_space IS NULL;
    END LOOP;

    OPEN c FOR query_str;
    RETURN c;
END search_phrase;
/
