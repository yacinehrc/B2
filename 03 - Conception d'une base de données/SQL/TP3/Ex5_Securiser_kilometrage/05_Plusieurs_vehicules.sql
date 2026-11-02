-- TP3 - Exercice 5 : plusieurs véhicules dans une même requête
USE TP3;
GO

UPDATE VEHICULE SET Kilometrage = Kilometrage + 200 WHERE IdVehicule IN (1, 2);

SELECT IdVehicule, Marque, Modele, Kilometrage, Statut FROM VEHICULE;
