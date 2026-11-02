-- TP3 - Exercice 5 : diminution du kilométrage (44 000 vers 42 000)
USE TP3;
GO

BEGIN TRY
    UPDATE VEHICULE SET Kilometrage = 42000 WHERE IdVehicule = 6;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK;

    SELECT ERROR_NUMBER() AS NumeroErreur, ERROR_MESSAGE() AS MessageErreur;
END CATCH;

SELECT IdVehicule, Marque, Modele, Kilometrage, Statut FROM VEHICULE;
