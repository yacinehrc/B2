-- TP3 : création de la base, des tables et des données
USE master;
GO

-- Repart d'une base vide si le script est relancé
IF DB_ID('TP3') IS NOT NULL
BEGIN
    ALTER DATABASE TP3 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TP3;
END;
GO

CREATE DATABASE TP3;
GO

USE TP3;
GO

CREATE TABLE CLIENT (
    IdClient INT PRIMARY KEY,
    Nom VARCHAR(50) NOT NULL,
    Prenom VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE VEHICULE (
    IdVehicule INT PRIMARY KEY,
    Immatriculation VARCHAR(20) NOT NULL UNIQUE,
    Marque VARCHAR(50) NOT NULL,
    Modele VARCHAR(50) NOT NULL,
    Categorie VARCHAR(30) NOT NULL,
    PrixJour DECIMAL(10,2) NOT NULL,
    Kilometrage INT NOT NULL,
    Statut VARCHAR(20) NOT NULL
);

CREATE TABLE LOCATION (
    IdLocation INT PRIMARY KEY,
    IdClient INT NOT NULL,
    IdVehicule INT NOT NULL,
    DateDebut DATE NOT NULL,
    DateFin DATE NOT NULL,
    PrixTotal DECIMAL(10,2) NOT NULL,
    Statut VARCHAR(20) NOT NULL,
    FOREIGN KEY (IdClient) REFERENCES CLIENT(IdClient),
    FOREIGN KEY (IdVehicule) REFERENCES VEHICULE(IdVehicule)
);

CREATE TABLE ENTRETIEN (
    IdEntretien INT PRIMARY KEY,
    IdVehicule INT NOT NULL,
    DateEntretien DATE NOT NULL,
    TypeEntretien VARCHAR(50) NOT NULL,
    Cout DECIMAL(10,2) NOT NULL,
    Kilometrage INT NOT NULL,
    FOREIGN KEY (IdVehicule) REFERENCES VEHICULE(IdVehicule)
);

INSERT INTO CLIENT VALUES
(1, 'Martin', 'Alice', 'alice@email.fr'),
(2, 'Durand', 'Paul', 'paul@email.fr'),
(3, 'Bernard', 'Lucie', 'lucie@email.fr');

INSERT INTO VEHICULE VALUES
(1, 'AA-123-AA', 'Renault', 'Clio', 'Citadine', 45.00, 15000, 'DISPONIBLE'),
(2, 'BB-234-BB', 'Peugeot', '208', 'Citadine', 75.00, 18000, 'DISPONIBLE'),
(3, 'CC-345-CC', 'Dacia', 'Duster', 'SUV', 70.00, 35000, 'DISPONIBLE'),
(4, 'DD-456-DD', 'Peugeot', '3008', 'SUV', 95.00, 62000, 'DISPONIBLE'),
(5, 'EE-567-EE', 'Renault', 'Master', 'Utilitaire', 110.00, 78000, 'ENTRETIEN'),
(6, 'FF-678-FF', 'Toyota', 'Corolla', 'Berline', 65.00, 42500, 'LOUE');

-- Les locations 3 et 5 ont un prix enregistré incohérent
INSERT INTO LOCATION VALUES
(1, 1, 1, '2026-10-10', '2026-10-13', 135.00, 'TERMINEE'),
(2, 2, 3, '2026-10-01', '2026-10-06', 350.00, 'TERMINEE'),
(3, 3, 6, '2026-10-20', '2026-10-24', 240.00, 'EN_COURS'),
(4, 1, 4, '2026-11-05', '2026-11-07', 190.00, 'RESERVEE'),
(5, 2, 2, '2026-09-10', '2026-09-13', 150.00, 'TERMINEE');

INSERT INTO ENTRETIEN VALUES
(1, 4, '2026-08-20', 'Vidange', 120.00, 60000),
(2, 5, '2026-10-25', 'Freins', 340.00, 78000);

SELECT IdVehicule, Marque, Modele, Categorie, PrixJour, Kilometrage, Statut FROM VEHICULE;
SELECT IdLocation, IdVehicule, DateDebut, DateFin, PrixTotal, Statut FROM LOCATION;
