-- TP1 - Exercice 4 : création de la base, des tables et des données
USE master;
GO

-- Repart d'une base vide si le script est relancé
IF DB_ID('TP1_Ex4') IS NOT NULL
BEGIN
    ALTER DATABASE TP1_Ex4 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TP1_Ex4;
END;
GO

CREATE DATABASE TP1_Ex4;
GO

USE TP1_Ex4;
GO

CREATE TABLE Client (
    IdClient INT PRIMARY KEY,
    Nom NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL
);

CREATE TABLE Commande (
    IdCommande INT PRIMARY KEY,
    DateCommande DATE NOT NULL,
    Statut NVARCHAR(30) NOT NULL,
    Montant DECIMAL(10,2) NOT NULL,
    IdClient INT NOT NULL,
    FOREIGN KEY (IdClient) REFERENCES Client(IdClient)
);

CREATE TABLE Paiement (
    IdPaiement INT IDENTITY PRIMARY KEY,
    IdCommande INT NOT NULL,
    Montant DECIMAL(10,2) NOT NULL,
    Statut NVARCHAR(30) NOT NULL,
    DatePaiement DATE NOT NULL,
    FOREIGN KEY (IdCommande) REFERENCES Commande(IdCommande)
);

CREATE TABLE Journal_Cloture (
    IdCloture INT IDENTITY PRIMARY KEY,
    DateCloture DATE NOT NULL,
    NombreCommandes INT NOT NULL,
    MontantTotal DECIMAL(12,2) NOT NULL,
    DateTraitement DATETIME2 NOT NULL
);

INSERT INTO Client VALUES
(1, 'Martin', 'martin@email.fr'),
(2, 'Durand', 'durand@email.fr'),
(3, 'Bernard', 'bernard@email.fr');

-- 15/09 : la commande 102 présente une anomalie (100 € payés pour 120 €)
-- 16/09 : journée sans anomalie
-- 17/09 : journée utilisée pour l'erreur volontaire
INSERT INTO Commande VALUES
(100, '2026-09-15', 'EN_ATTENTE', 50.00, 1),
(101, '2026-09-15', 'EN_ATTENTE', 80.00, 2),
(102, '2026-09-15', 'EN_ATTENTE', 120.00, 3),
(103, '2026-09-16', 'EN_ATTENTE', 40.00, 1),
(104, '2026-09-16', 'EN_ATTENTE', 60.00, 2),
(105, '2026-09-16', 'EN_ATTENTE', 90.00, 3),
(106, '2026-09-17', 'EN_ATTENTE', 30.00, 1),
(107, '2026-09-17', 'EN_ATTENTE', 70.00, 2);

INSERT INTO Paiement
(
    IdCommande,
    Montant,
    Statut,
    DatePaiement
)
VALUES
(100, 50.00, 'VALIDE', '2026-09-15'),
(101, 80.00, 'VALIDE', '2026-09-15'),
(102, 100.00, 'VALIDE', '2026-09-15'),
(103, 40.00, 'VALIDE', '2026-09-16'),
(104, 60.00, 'VALIDE', '2026-09-16'),
(105, 90.00, 'VALIDE', '2026-09-16'),
(106, 30.00, 'VALIDE', '2026-09-17'),
(107, 70.00, 'VALIDE', '2026-09-17');

SELECT IdCommande, DateCommande, Statut, Montant FROM Commande;
