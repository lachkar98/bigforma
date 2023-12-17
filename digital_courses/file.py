import streamlit as st  
import cx_Oracle
import pandas as pd
import oracledb
import spacy
from spacy.lang.fr.stop_words import STOP_WORDS as fr_stop

# Charger le modèle français
nlp = spacy.load("fr_core_news_sm")

def is_valid_sentence(text, word_threshold=3):
    """ Vérifie si le texte ressemble à une phrase valide. """
    words = text.split()
    return len(words) >= word_threshold

def filter_keywords_spacy(sentence):
    if is_valid_sentence(sentence):
        # Tokeniser la phrase avec Spacy
        doc = nlp(sentence)
    
        # Filtrer les stop words et les mots non significatifs, sauf pour les exceptions
        keywords = [token.text for token in doc if (token.text.lower() not in fr_stop and token.pos_ in ["ADJ", "NOUN", "VERB", "PROPN"])]

        return ' '.join(keywords)
    else:
        # Retourner la phrase originale si elle ne remplit pas les critères de longueur
        return sentence


def fetch_search_results(search_term):
    corrected_keyword=filter_keywords_spacy(search_term)

    # Oracle database connection string - modify with your details
    dsn_tns = cx_Oracle.makedsn('localhost', '1521', service_name='xe')
    connection = cx_Oracle.connect(user='sys', password='projet_bda',mode=cx_Oracle.SYSDBA, dsn=dsn_tns)

   
    # Create a cursor
    cursor = connection.cursor()
    cursor.callproc("dbms_output.enable")

    # Call the PL/SQL function to retrieve course names
    cursor.execute("""
    DECLARE
        resultat VARCHAR2(32767);
    BEGIN
        resultat := trouver_lignes_avec_mots_similaires(:keyword);
        DBMS_OUTPUT.PUT_LINE(resultat);
    END;
    """, keyword=corrected_keyword)



       # Liste pour stocker les résultats de DBMS_OUTPUT
    results = []

    # Récupérer et ajouter les lignes de DBMS_OUTPUT à la liste
    statusVar = cursor.var(cx_Oracle.NUMBER)
    lineVar = cursor.var(cx_Oracle.STRING)
    while True:
        cursor.callproc("dbms_output.get_line", (lineVar, statusVar))
        if statusVar.getvalue() != 0:
            break
    
        print('aw')
        results.append(lineVar.getvalue())

    # Traiter les résultats si non vides
    if results[0]:
        # Diviser la première chaîne de caractères en utilisant ';' comme séparateur
        results = results[0].split(';')
        
        # Supprimer les espaces blancs et les chaînes vides de la liste
        results = [item.strip() for item in results if item.strip()]

    print(len(results))
    print(type(results))
    print(results[4])





    # Prepare the SQL query with CLOB to VARCHAR2 conversion
    query = """
        SELECT * FROM SOUSSOUSDomaineFormation 
        WHERE DBMS_LOB.SUBSTR(Le_nom, 4000, 1) IN (:course_names)
    """

    dfs=[]
    for course_name in results :
        # Assuming results[4] is a single course name
        
        
        # Execute thse query
        cursor.execute(query, course_names=course_name)


        # Fetch all rows
        rows = cursor.fetchall()

        # Get column names from the cursor description
        columns = [col[0] for col in cursor.description]
    
        # Create DataFrame from the fetched data
        df = pd.DataFrame(rows, columns=columns)

        dfs.append(df)

    final_df = pd.concat(dfs, ignore_index=True)
    












    return final_df

results = fetch_search_results('big data')
print(results.head(80))



