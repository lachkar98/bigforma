# État d'Avancement du Projet
----------------------------

- **Prototype de Base de Données :** Un prototype de la base de données a été créé avec succès.

- **Résultats du Scraping Web :** Le scraping de trois sites cibles a été réalisé, les données étant actuellement stockées dans des fichiers .csv. Cela inclut tous les sites sauf Coursera, qui sera intégré ultérieurement.

- **Insertions de Données :** Les données provenant de Cegos sont les plus récentes, incluant les mots-clés pour chaque formation. Les données de Coursera et Udemy seront intégrées par la suite.

- **Échantillonnage :** Pour le moment, seules des données échantillonnées ont été utilisées pour les insertions.

- **Mises à Jour des Fichiers :** Les fichiers .CSV et .SQL relatifs à Cegos sont les plus à jour.

- **Efforts d'Homogénéisation :** Des premières étapes vers l'homogénéisation des données ont été entreprises.

- **Méta-tables :** La création des méta-tables a commencé, bien que le script correspondant n'ait pas encore été ajouté. Elles seront finalisées dans les phases ultérieures du projet.

# Projet BigForma Back-end par python
* il faut installer les libraries : 
* 1 - installer Flask 
* 2 - cx_Oracle preferable d'utiliser anaconda -> conda install cx_Oracle
* _un test pour afficher les domains formations_
* changer le donnees dans fichier bd.py host, port et service_name
* executer le fichier main
* lancer une requete get prefix//domain-form
* dans mon cas prefix = http://127.0.0.1:5000 (s'affiche après execution de main.py)