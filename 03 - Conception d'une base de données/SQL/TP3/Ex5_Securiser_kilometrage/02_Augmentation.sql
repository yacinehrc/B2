-- TP3 - Exercice 5 : augmentation du kilométrage
USE TP3;
GO

UPDATE VEHICULE SET Kilometrage = 44000 WHERE IdVehicule = 6;

SELECT IdVehicule, Marque, Modele, Kilometrage, Statut FROM VEHICULE;
