-- TP1 - Exercice 3 : création de la base, des tables et des données
USE master;
GO

-- Repart d'une base vide si le script est relancé
IF DB_ID('TP1_Ex3') IS NOT NULL
BEGIN
    ALTER DATABASE TP1_Ex3 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TP1_Ex3;
END;
GO

CREATE DATABASE TP1_Ex3;
GO

USE TP1_Ex3;
GO

CREATE TABLE Agence (
    IdAgence INT PRIMARY KEY,
    Nom NVARCHAR(100) NOT NULL,
    Ville NVARCHAR(100) NOT NULL
);

CREATE TABLE Client (
    IdClient INT PRIMARY KEY,
    Nom NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    IdAgence INT NOT NULL,
    FOREIGN KEY (IdAgence) REFERENCES Agence(IdAgence)
);

CREATE TABLE Historique_Affectation (
    IdAffectation INT IDENTITY PRIMARY KEY,
    IdClient INT NOT NULL,
    IdAgence INT NOT NULL,
    DateDebut DATE NOT NULL,
    DateFin DATE NULL,
    FOREIGN KEY (IdClient) REFERENCES Client(IdClient),
    FOREIGN KEY (IdAgence) REFERENCES Agence(IdAgence)
);

INSERT INTO Agence VALUES
(1, 'Agence Lille', 'Lille'),
(2, 'Agence Roubaix', 'Roubaix'),
(3, 'Agence Arras', 'Arras');

INSERT INTO Client VALUES
(1, 'Martin', 'martin@email.fr', 1),
(2, 'Durand', 'durand@email.fr', 2);

INSERT INTO Historique_Affectation
(
    IdClient,
    IdAgence,
    DateDebut,
    DateFin
)
VALUES
(1, 1, '2026-01-01', NULL),
(2, 2, '2026-01-01', NULL);

SELECT * FROM Agence;
SELECT IdClient, Nom, IdAgence FROM Client;
SELECT IdAffectation, IdClient, IdAgence, DateDebut, DateFin FROM Historique_Affectation;
