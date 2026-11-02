-- TP3 - Exercice 4 : cas 4, plusieurs véhicules dans une seule requête
USE TP3;
GO

UPDATE VEHICULE SET Kilometrage = Kilometrage + 100 WHERE IdVehicule IN (4, 5, 6);

SELECT IdVehicule, AncienStatut, NouveauStatut, AncienKilometrage, NouveauKilometrage FROM HISTORIQUE_VEHICULE;
