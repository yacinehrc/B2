-- TP1 - Exercice 1 : création de la base, des tables et des données
USE master;
GO

-- Repart d'une base vide si le script est relancé
IF DB_ID('TP1_Ex1') IS NOT NULL
BEGIN
    ALTER DATABASE TP1_Ex1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TP1_Ex1;
END;
GO

CREATE DATABASE TP1_Ex1;
GO

USE TP1_Ex1;
GO

CREATE TABLE Client (
    IdClient INT PRIMARY KEY,
    Nom NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE Commande (
    IdCommande INT PRIMARY KEY,
    DateCommande DATE NOT NULL,
    Statut NVARCHAR(20) NOT NULL,
    IdClient INT NOT NULL,
    CONSTRAINT FK_Commande_Client
        FOREIGN KEY (IdClient) REFERENCES Client(IdClient),
    CONSTRAINT CK_Commande_Statut
        CHECK (Statut IN ('BROUILLON', 'VALIDEE', 'ANNULEE'))
);

CREATE TABLE Produit (
    IdProduit INT PRIMARY KEY,
    Reference NVARCHAR(50) NOT NULL UNIQUE,
    Libelle NVARCHAR(150) NOT NULL,
    Prix DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    CONSTRAINT CK_Produit_Prix CHECK (Prix >= 0),
    CONSTRAINT CK_Produit_Stock CHECK (Stock >= 0)
);

CREATE TABLE Ligne_Commande (
    IdCommande INT NOT NULL,
    IdProduit INT NOT NULL,
    Quantite INT NOT NULL,
    PRIMARY KEY (IdCommande, IdProduit),
    FOREIGN KEY (IdCommande) REFERENCES Commande(IdCommande),
    FOREIGN KEY (IdProduit) REFERENCES Produit(IdProduit),
    CONSTRAINT CK_Ligne_Commande_Quantite CHECK (Quantite > 0)
);

CREATE TABLE Mouvement_Stock (
    IdMouvement INT IDENTITY PRIMARY KEY,
    IdProduit INT NOT NULL,
    DateMouvement DATETIME2 NOT NULL,
    Quantite INT NOT NULL,
    TypeMouvement NVARCHAR(20) NOT NULL,
    IdCommande INT NOT NULL,
    FOREIGN KEY (IdProduit) REFERENCES Produit(IdProduit),
    FOREIGN KEY (IdCommande) REFERENCES Commande(IdCommande)
);

INSERT INTO Client VALUES
(1, 'Martin', 'martin@email.fr'),
(2, 'Durand', 'durand@email.fr');

INSERT INTO Produit VALUES
(1, 'SOURIS-01', 'Souris sans fil', 25.00, 10),
(2, 'CLAVIER-01', 'Clavier', 45.00, 2),
(3, 'ECRAN-24', 'Écran 24 pouces', 180.00, 5),
(4, 'CABLE-HDMI', 'Câble HDMI', 12.00, 20);

INSERT INTO Commande VALUES
(100, '2026-09-15', 'BROUILLON', 1),
(101, '2026-09-15', 'BROUILLON', 2),
(102, '2026-09-16', 'BROUILLON', 1),
(103, '2026-09-16', 'BROUILLON', 2);

INSERT INTO Ligne_Commande VALUES
(100, 1, 2),
(101, 1, 1),
(101, 2, 3),
(102, 1, 1),
(102, 3, 1),
(102, 4, 5),
(103, 3, 1);

SELECT IdCommande, Statut FROM Commande;
SELECT IdProduit, Libelle, Stock FROM Produit;
SELECT * FROM Ligne_Commande;
