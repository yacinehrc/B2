-- TP3 - Exercice 6 : trigger du développeur junior, il fonctionne sur une seule ligne
USE TP3;
GO

-- Le trigger de l'exercice 5 est désactivé pour observer celui-ci seul
DISABLE TRIGGER dbo.trg_Vehicule_KilometrageCroissant ON dbo.VEHICULE;
GO

CREATE OR ALTER TRIGGER dbo.trg_ControleKilometrage
ON dbo.VEHICULE
AFTER UPDATE
AS
BEGIN

    DECLARE @IdVehicule INT;
    DECLARE @AncienKm INT;
    DECLARE @NouveauKm INT;

    SELECT
        @IdVehicule = IdVehicule,
        @AncienKm = Kilometrage
    FROM deleted;

    SELECT
        @NouveauKm = Kilometrage
    FROM inserted;

    IF @NouveauKm < @AncienKm
    BEGIN
        THROW 50001, 'Le kilometrage ne peut pas diminuer.', 1;
    END;

END;
GO

BEGIN TRY
    UPDATE VEHICULE SET Kilometrage = 1000 WHERE IdVehicule = 1;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK;

    SELECT ERROR_NUMBER() AS NumeroErreur, ERROR_MESSAGE() AS MessageErreur;
END CATCH;

SELECT IdVehicule, Marque, Modele, Kilometrage, Statut FROM VEHICULE;
