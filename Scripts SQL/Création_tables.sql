DROP TABLE Specialitee CASCADE CONSTRAINTS;
DROP TABLE SousDomaineFormation CASCADE CONSTRAINTS;
DROP TABLE SOUSSOUSDomaineFormation CASCADE CONSTRAINTS;
DROP TABLE Client_Apprenant CASCADE CONSTRAINTS;
DROP TABLE Formateur CASCADE CONSTRAINTS;
DROP TABLE Demander CASCADE CONSTRAINTS;
DROP TABLE SeDeclarer CASCADE CONSTRAINTS;
DROP TABLE Appartenir CASCADE CONSTRAINTS;
DROP TABLE Assurer CASCADE CONSTRAINTS;
DROP TABLE DomaineFormation CASCADE CONSTRAINTS;
DROP TABLE OrganismeDeFormation CASCADE CONSTRAINTS;
DROP TABLE Inscription CASCADE CONSTRAINTS;
DROP TABLE LaSession CASCADE CONSTRAINTS;


CREATE TABLE ABREVIATIONS (
    ID INT PRIMARY KEY,
    ORIGINAL_TEXT VARCHAR(255),
    ABBREVIATION VARCHAR(255)
);

-- Création de la table Specialitee
CREATE TABLE Specialitee (
    NumeroSpecialite VARCHAR(20) PRIMARY KEY,
    IntituleSpecialite VARCHAR(50),
    Description CLOB
);



-- Création de la table DomaineFormation
drop table DomaineFormation;
CREATE TABLE DomaineFormation (
    RefDomaine VARCHAR(200) PRIMARY KEY,
    DomaineDeFormation VARCHAR2(50),
    MotsCles CLOB,  -- Oracle utilise CLOB pour les grands objets textuels
    DateCreation DATE
);

-- Création de la table SousDomaineFormation
drop table SousDomaineFormation;
CREATE TABLE SousDomaineFormation (
    RefSousDomaine VARCHAR(200) PRIMARY KEY,
    RefDomaine VARCHAR(200),
    SousDomaineDeFormation VARCHAR(200),
    Description CLOB,  -- Oracle utilise CLOB pour les grands objets textuels
    MotsCles CLOB,
    FOREIGN KEY (RefDomaine) REFERENCES DomaineFormation(RefDomaine)
);
drop table SOUSSOUSDomaineFormation;
CREATE TABLE SOUSSOUSDomaineFormation (
    RefSOUSSOUSDomaineF VARCHAR2(200) PRIMARY KEY,
    RefSOUSDomaineF VARCHAR2(200),
    Le_nom CLOB,
    Descriptio CLOB,
    Notes VARCHAR2(50),
    Nombre_avis VARCHAR2(10),
    Duree VARCHAR2(50),  -- Utiliser VARCHAR2 pour les champs textuels
    Nombre_participants INTEGER,
    Niveau VARCHAR2(50),
    Liens CLOB,
    Destinataires CLOB,
    Formateurs CLOB,
    Chapitre CLOB,
    Competences_gagnees CLOB,
    Organisation CLOB,
    MotsCles CLOB,
    FOREIGN KEY (RefSOUSDomaineF) REFERENCES SousDomaineFormation(RefSousDomaine)
);




-- Création de la table OrganismeDeFormation
CREATE TABLE OrganismeDeFormation (
    SIREN VARCHAR(20) PRIMARY KEY,
    RaisonSocial VARCHAR(20),
    Ville VARCHAR(50),
    Pays VARCHAR(50),
    Adresse VARCHAR(50),
    NumDeTelephone VARCHAR(20),
    Email VARCHAR(50),
    SiteWeb VARCHAR(50),
    TypeOrganisme VARCHAR(50)
);

-- Création de la table Formateur
CREATE TABLE Formateur (
    IdFormateur VARCHAR(20) PRIMARY KEY,
    NomFormateur VARCHAR(50),
    PrenomFormateur VARCHAR(50),
    AdresseEmail VARCHAR(50),
    TelephoneFormateur VARCHAR(20),
    DateEmbauche DATE
);

-- Création de la table Client_Apprenant
CREATE TABLE Client_Apprenant (
    IdClient VARCHAR(20) PRIMARY KEY,
    NomClient VARCHAR(50),
    PrenomClient VARCHAR(50),
    GenreContact VARCHAR(20),
    DatePremierContact DATE,
    DateNaissance DATE,
    AdresseEmail VARCHAR(50)
);

-- Création de la table LaSession
CREATE TABLE LaSession (
    IdLaSession VARCHAR(20) PRIMARY KEY,
    IdFormateur VARCHAR(20),
    Date_Debut DATE,
    Date_Fin DATE,
    SIRENOrganismeFormation VARCHAR(20),
    FOREIGN KEY (IdFormateur) REFERENCES Formateur(IdFormateur),
    FOREIGN KEY (SIRENOrganismeFormation) REFERENCES OrganismeDeFormation(SIREN)
);

-- Création de la table Assurer
CREATE TABLE Assurer (
    organismeformation_SIREN VARCHAR(20),
    SOUSSOUSdomaineFormation_Ref VARCHAR(20),
    PRIMARY KEY (organismeformation_SIREN, SOUSSOUSdomaineFormation_Ref),
    FOREIGN KEY (organismeformation_SIREN) REFERENCES OrganismeDeFormation(SIREN),
    FOREIGN KEY (SOUSSOUSdomaineFormation_Ref) REFERENCES SOUSSOUSDomaineFormation(RefSOUSSOUSDomaineF)
);

-- Création de la table Demander
CREATE TABLE Demander (
    ClientApprenant_IdClient VARCHAR(20),
    SOUSSOUSdomaineFormation_Id VARCHAR(20),
    PRIMARY KEY (ClientApprenant_IdClient, SOUSSOUSdomaineFormation_Id),
    FOREIGN KEY (ClientApprenant_IdClient) REFERENCES Client_Apprenant(IdClient),
    FOREIGN KEY (SOUSSOUSdomaineFormation_Id) REFERENCES SOUSSOUSDomaineFormation(RefSOUSSOUSDomaineF)
);

-- Création de la table SeDeclarer
CREATE TABLE SeDeclarer (
    organismeformation_SIREN VARCHAR(20),
    specialite_numero_specialite VARCHAR(20),
    PRIMARY KEY (organismeformation_SIREN, specialite_numero_specialite),
    FOREIGN KEY (organismeformation_SIREN) REFERENCES OrganismeDeFormation(SIREN),
    FOREIGN KEY (specialite_numero_specialite) REFERENCES Specialitee(NumeroSpecialite)
);

-- Création de la table Appartenir
CREATE TABLE Appartenir (
    formateur_idformateur VARCHAR(20),
    organismeformation_SIREN VARCHAR(20),
    PRIMARY KEY (formateur_idformateur, organismeformation_SIREN),
    FOREIGN KEY (formateur_idformateur) REFERENCES Formateur(IdFormateur),
    FOREIGN KEY (organismeformation_SIREN) REFERENCES OrganismeDeFormation(SIREN)
);


CREATE TABLE Inscription (
    IdClient VARCHAR(20),
    IdLaSession VARCHAR(20),
    PRIMARY KEY (IdClient, IdLaSession),
    FOREIGN KEY (IdClient) REFERENCES Client_Apprenant(IdClient),
    FOREIGN KEY (IdLaSession) REFERENCES LaSession(IdLaSession)
);
