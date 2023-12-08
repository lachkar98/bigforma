--meta-data big forma
--meta-table
DROP TABLE META_TABLES;
CREATE TABLE META_TABLES (
    ID_TABLE INT PRIMARY KEY,
    NOM_TABLE VARCHAR2(50),
    DATE_CREATION DATE,
    NOMBRE_COLONNES INT,
    NOMBRE_LIGNES INT,
    COMMENTAIRES CLOB
);

-- insertion de des tables
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (1,'ABREVIATIONS','ABREVIATIONS');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (2,'Specialitee','Specialitee');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (3,'DomaineFormation','DomaineFormation');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (4,'SousDomaineFormation','SousDomaineFormation');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (5,'SOUSSOUSDomaineFormation','SOUSSOUSDomaineFormation');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (6,'OrganismeDeFormation','OrganismeDeFormation');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (7,'Formateur','Formateur');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (8,'Client_Apprenant','Client_Apprenant');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (9,'LaSession','LaSession');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (10,'Demander','Demander');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (11,'SeDeclarer','SeDeclarer');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (12,'Appartenir','Appartenir');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (13,'Inscription','Inscription');

--insertion de nombre de lignes
BEGIN
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from ABREVIATIONS) where ID_TABLE = 1;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from Specialitee) where ID_TABLE = 2;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from DomaineFormation) where ID_TABLE = 3;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from SousDomaineFormation) where ID_TABLE = 4;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from SOUSSOUSDomaineFormation) where ID_TABLE = 5;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from OrganismeDeFormation) where ID_TABLE = 6;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from Formateur) where ID_TABLE = 7;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from Client_Apprenant) where ID_TABLE = 8;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from LaSession) where ID_TABLE = 9;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from Demander) where ID_TABLE = 10;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from SeDeclarer) where ID_TABLE = 11;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from Appartenir) where ID_TABLE = 12;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from Inscription) where ID_TABLE = 13;  
END;
/

--insertion date creation
UPDATE META_TABLES SET DATE_CREATION = ( SELECT created FROM all_objects WHERE object_type = 'TABLE' AND object_name = 'DOMAINEFORMATION' ); 

--insertions des nombre de colonne
SELECT COUNT(*) FROM all_tab_columns WHERE table_name = 'DOMAINEFORMATION';
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('ABREVIATIONS')) where ID_TABLE = 1;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('Specialitee')) where ID_TABLE = 2;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('DomaineFormation')) where ID_TABLE = 3;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('SousDomaineFormation')) where ID_TABLE = 4;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('SOUSSOUSDomaineFormation')) where ID_TABLE = 5;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('OrganismeDeFormation')) where ID_TABLE = 6;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('Formateur')) where ID_TABLE = 7;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('Client_Apprenant')) where ID_TABLE = 8;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('LaSession')) where ID_TABLE = 9;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('Demander')) where ID_TABLE = 10;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('SeDeclarer')) where ID_TABLE = 11;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('Appartenir')) where ID_TABLE = 12;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('Inscription')) where ID_TABLE = 13;

select * from META_TABLES;
--------------------------------------------------------------------------------
--meta-colonne
DROP TABLE META_COLONNES; 
create table META_COLONNES(
    ID_COLONNE NUMBER primary key,
    NOM_TABLE varchar(50),
    NOM_COLONNE varchar(50),
    DATE_CREATION DATE,
    DATE_DIAGNOSTIQUE DATE,
    NOMBRE_VAL NUMBER,
    NOMBRE_VM NUMBER,
    --NOMBRE_LIGNES NUMBER,
    NOMBRE_SPE_CHAR NUMBER,
    TYPE_COLONNE VARCHAR(50),
    NOMBRE_ANOMALIES NUMBER,
    OUTLAYER_VALS NUMBER,
    EXPRESSION_REGULIERE VARCHAR(100),
    NEGATIF NUMBER,
    NOMBRE_ESPACES NUMBER,
    TYPE_CLEF VARCHAR(50),
    --FORMAT_RESPECT NUMBER(1) CHECK (FORMAT_RESPECT IN (0, 1)),
    --DEVISE VARCHAR(30),
    EXISTANCE_CHIFFRES NUMBER(1) CHECK (EXISTANCE_CHIFFRES in (0,1)),
    TAILLE_MEMOIRE NUMBER,
    NOMBRE_REPETITION_CHAR NUMBER,
    NOMBRE_VALEUR_UNIQUE NUMBER,
    NOMBRE_DOUBLONS NUMBER,
    PROPORTION_INITCAP NUMBER,
    PROPORTION_UPPER NUMBER,
    PROPORTION_LOWER NUMBER
);
