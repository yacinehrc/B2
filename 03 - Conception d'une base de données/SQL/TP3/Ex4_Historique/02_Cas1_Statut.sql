-- TP3 - Exercice 4 : cas 1, modification du statut
USE TP3;
GO

UPDATE VEHICULE SET Statut = 'LOUE' WHERE IdVehicule = 1;

SELECT IdVehicule, AncienStatut, NouveauStatut, AncienKilometrage, NouveauKilometrage FROM HISTORIQUE_VEHICULE;
