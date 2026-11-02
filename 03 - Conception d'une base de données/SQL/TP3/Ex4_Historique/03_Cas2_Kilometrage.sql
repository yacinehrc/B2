-- TP3 - Exercice 4 : cas 2, modification du kilométrage
USE TP3;
GO

UPDATE VEHICULE SET Kilometrage = 18500 WHERE IdVehicule = 2;

SELECT IdVehicule, AncienStatut, NouveauStatut, AncienKilometrage, NouveauKilometrage FROM HISTORIQUE_VEHICULE;
