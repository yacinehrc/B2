-- TP1 - Exercice 5 : création de la base, des tables et des données
USE master;
GO

-- Repart d'une base vide si le script est relancé
IF DB_ID('TP1_Ex5') IS NOT NULL
BEGIN
    ALTER DATABASE TP1_Ex5 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TP1_Ex5;
END;
GO

CREATE DATABASE TP1_Ex5;
GO

USE TP1_Ex5;
GO

CREATE TABLE Commande (
    IdCommande INT PRIMARY KEY,
    DateCommande DATE NOT NULL,
    Statut NVARCHAR(20) NOT NULL
);

CREATE TABLE Produit (
    IdProduit INT PRIMARY KEY,
    Libelle NVARCHAR(150) NOT NULL,
    Stock INT NOT NULL,
    CONSTRAINT CK_Produit_Stock CHECK (Stock >= 0)
);

CREATE TABLE MouvementStock (
    IdMouvement INT IDENTITY PRIMARY KEY,
    IdProduit INT NOT NULL,
    Quantite INT NOT NULL,
    TypeMouvement NVARCHAR(20) NOT NULL,
    DateMouvement DATETIME2 NOT NULL,
    IdCommande INT NOT NULL,
    FOREIGN KEY (IdProduit) REFERENCES Produit(IdProduit),
    FOREIGN KEY (IdCommande) REFERENCES Commande(IdCommande)
);

INSERT INTO Commande VALUES
(100, '2026-09-15', 'BROUILLON'),
(101, '2026-09-15', 'BROUILLON');

INSERT INTO Produit VALUES
(1, 'Souris sans fil', 10);

SELECT IdCommande, Statut FROM Commande;
SELECT IdProduit, Libelle, Stock FROM Produit;
SELECT IdProduit, Quantite, TypeMouvement, IdCommande FROM MouvementStock;
