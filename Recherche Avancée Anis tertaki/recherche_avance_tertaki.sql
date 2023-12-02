--- j'ai appliqué l'algorithme sur une petit portion de la data car il prend un temps enorme si on le fait pour toute la data
--- c'est le prmeier souci et le deuxième souci c'est qu'il m'affiche le mot clé trouvé plusieurs fois et jsp pourquoi !
--- vous pouvez continuez dessus, je vais y continuer quand j'aurais le temps

Drop table NewTable;
-- Create a new table (if it doesn't exist)
CREATE TABLE NewTable AS
SELECT *
FROM SOUSSOUSDomaineFormation
WHERE ROWNUM <= 5;

select * from newtable;







CREATE OR REPLACE FUNCTION find_similar_keywords(p_search_string VARCHAR2) RETURN VARCHAR2 IS
   v_similarity_threshold NUMBER := 80; -- Ajustez le seuil de similarité selon vos besoins
   v_found_keywords VARCHAR2(4000);
BEGIN
   -- Utilisez la fonction UTL_MATCH.JARO_WINKLER_SIMILARITY pour calculer la similarité
   -- entre la chaîne de recherche et les mots-clés dans la table
   SELECT LISTAGG(keyword, ', ') WITHIN GROUP (ORDER BY similarity DESC) INTO v_found_keywords
   FROM (
      SELECT keyword, UTL_MATCH.JARO_WINKLER_SIMILARITY(keyword, p_search_string) AS similarity
      FROM (
         SELECT TRIM(regexp_substr(MOTSCLES, '[^,]+', 1, LEVEL)) AS keyword
         FROM NewTable
         CONNECT BY LEVEL <= REGEXP_COUNT(MOTSCLES, ',') + 1
      )
      WHERE UTL_MATCH.JARO_WINKLER_SIMILARITY(keyword, p_search_string) > v_similarity_threshold
   )
   WHERE ROWNUM <= 5; -- Limitez le nombre de résultats selon vos préférences

   RETURN v_found_keywords;
END find_similar_keywords;
/






SET SERVEROUTPUT ON

DECLARE
   v_keywords VARCHAR2(4000);
BEGIN
   v_keywords := find_similar_keywords('nouvele');
   DBMS_OUTPUT.PUT_LINE('Similar Keywords: ' || v_keywords);
END;
/






