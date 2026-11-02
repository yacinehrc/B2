-- TP2 : création de la base et des tables
USE master;
GO

-- Repart d'une base vide si le script est relancé
IF DB_ID('TP2') IS NOT NULL
BEGIN
    ALTER DATABASE TP2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TP2;
END;
GO

CREATE DATABASE TP2;
GO

USE TP2;
GO

CREATE TABLE CLIENT (
    IdClient INT PRIMARY KEY,
    Nom VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE APPAREIL (
    IdAppareil INT PRIMARY KEY,
    IdClient INT NOT NULL,
    TypeAppareil VARCHAR(30) NOT NULL,
    Marque VARCHAR(50) NOT NULL,
    Modele VARCHAR(50) NOT NULL,
    FOREIGN KEY (IdClient) REFERENCES CLIENT(IdClient)
);

CREATE TABLE TECHNICIEN (
    IdTechnicien INT PRIMARY KEY,
    Nom VARCHAR(50) NOT NULL,
    Specialite VARCHAR(50) NOT NULL
);

CREATE TABLE REPARATION (
    IdReparation INT PRIMARY KEY,
    IdAppareil INT NOT NULL,
    IdTechnicien INT NOT NULL,
    DateDepot DATE NOT NULL,
    Statut VARCHAR(20) NOT NULL,
    Montant DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (IdAppareil) REFERENCES APPAREIL(IdAppareil),
    FOREIGN KEY (IdTechnicien) REFERENCES TECHNICIEN(IdTechnicien),
    CONSTRAINT CK_Reparation_Statut
        CHECK (Statut IN ('EN_ATTENTE', 'EN_COURS', 'TERMINEE', 'ANNULEE')),
    CONSTRAINT CK_Reparation_Montant CHECK (Montant >= 0)
);

CREATE TABLE INTERVENTION (
    IdIntervention INT IDENTITY PRIMARY KEY,
    IdReparation INT NOT NULL,
    DateIntervention DATETIME NOT NULL,
    Description VARCHAR(255) NOT NULL,
    DureeMinutes INT NOT NULL,
    FOREIGN KEY (IdReparation) REFERENCES REPARATION(IdReparation)
);

CREATE TABLE PAIEMENT (
    IdPaiement INT IDENTITY PRIMARY KEY,
    IdReparation INT NOT NULL,
    DatePaiement DATE NOT NULL,
    Montant DECIMAL(10,2) NOT NULL,
    Statut VARCHAR(20) NOT NULL,
    FOREIGN KEY (IdReparation) REFERENCES REPARATION(IdReparation),
    CONSTRAINT CK_Paiement_Statut
        CHECK (Statut IN ('EN_ATTENTE', 'VALIDE', 'REFUSE'))
);
