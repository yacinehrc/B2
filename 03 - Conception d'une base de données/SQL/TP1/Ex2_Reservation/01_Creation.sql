-- TP1 - Exercice 2 : création de la base, des tables et des données
USE master;
GO

-- Repart d'une base vide si le script est relancé
IF DB_ID('TP1_Ex2') IS NOT NULL
BEGIN
    ALTER DATABASE TP1_Ex2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TP1_Ex2;
END;
GO

CREATE DATABASE TP1_Ex2;
GO

USE TP1_Ex2;
GO

CREATE TABLE Client (
    IdClient INT PRIMARY KEY,
    Nom NVARCHAR(100) NOT NULL,
    Prenom NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE Vehicule (
    IdVehicule INT PRIMARY KEY,
    Immatriculation NVARCHAR(20) NOT NULL UNIQUE,
    Marque NVARCHAR(50) NOT NULL,
    Modele NVARCHAR(50) NOT NULL,
    Statut NVARCHAR(20) NOT NULL,
    CONSTRAINT CK_Vehicule_Statut
        CHECK (Statut IN ('DISPONIBLE', 'RESERVE', 'ENTRETIEN'))
);

CREATE TABLE Reservation (
    IdReservation INT PRIMARY KEY,
    IdClient INT NOT NULL,
    IdVehicule INT NOT NULL,
    DateDebut DATE NOT NULL,
    DateFin DATE NOT NULL,
    Statut NVARCHAR(20) NOT NULL,
    Montant DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (IdClient) REFERENCES Client(IdClient),
    FOREIGN KEY (IdVehicule) REFERENCES Vehicule(IdVehicule),
    CONSTRAINT CK_Reservation_Dates
        CHECK (DateFin > DateDebut)
);

CREATE TABLE Paiement (
    IdPaiement INT IDENTITY PRIMARY KEY,
    IdReservation INT NOT NULL,
    DatePaiement DATETIME2 NOT NULL,
    Montant DECIMAL(10,2) NOT NULL,
    Statut NVARCHAR(20) NOT NULL,
    FOREIGN KEY (IdReservation) REFERENCES Reservation(IdReservation)
);

CREATE TABLE Historique_Vehicule (
    IdHistorique INT IDENTITY PRIMARY KEY,
    IdVehicule INT NOT NULL,
    DateEvenement DATETIME2 NOT NULL,
    Evenement NVARCHAR(200) NOT NULL,
    IdReservation INT NOT NULL,
    FOREIGN KEY (IdVehicule) REFERENCES Vehicule(IdVehicule),
    FOREIGN KEY (IdReservation) REFERENCES Reservation(IdReservation)
);

INSERT INTO Client VALUES
(1, 'Martin', 'Alice', 'alice@email.fr'),
(2, 'Durand', 'Paul', 'paul@email.fr');

INSERT INTO Vehicule VALUES
(1, 'AA-123-AA', 'Renault', 'Clio', 'DISPONIBLE'),
(2, 'BB-456-BB', 'Peugeot', '308', 'ENTRETIEN'),
(3, 'CC-789-CC', 'Dacia', 'Duster', 'DISPONIBLE');

INSERT INTO Reservation VALUES
(100, 1, 1, '2026-09-20', '2026-09-25', 'EN_ATTENTE', 350.00),
(101, 2, 2, '2026-09-20', '2026-09-22', 'EN_ATTENTE', 120.00),
(102, 2, 3, '2026-10-01', '2026-10-04', 'EN_ATTENTE', 210.00);

SELECT IdReservation, IdVehicule, Statut, Montant FROM Reservation;
SELECT IdVehicule, Immatriculation, Statut FROM Vehicule;
