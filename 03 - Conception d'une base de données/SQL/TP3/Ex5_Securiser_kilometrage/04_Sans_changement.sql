-- TP3 - Exercice 5 : modification sans changement de kilométrage
USE TP3;
GO

UPDATE VEHICULE SET Statut = 'DISPONIBLE' WHERE IdVehicule = 6;

SELECT IdVehicule, Marque, Modele, Kilometrage, Statut FROM VEHICULE;
