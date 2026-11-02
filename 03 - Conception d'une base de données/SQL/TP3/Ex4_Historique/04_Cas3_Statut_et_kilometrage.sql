-- TP3 - Exercice 4 : cas 3, statut et kilométrage en même temps
USE TP3;
GO

UPDATE VEHICULE SET Statut = 'ENTRETIEN', Kilometrage = 35400 WHERE IdVehicule = 3;

SELECT IdVehicule, AncienStatut, NouveauStatut, AncienKilometrage, NouveauKilometrage FROM HISTORIQUE_VEHICULE;
