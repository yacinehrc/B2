-- TP3 - Exercice 6 : correction testée sur plusieurs lignes valides
USE TP3;
GO

BEGIN TRY
    UPDATE VEHICULE SET Kilometrage = Kilometrage + 100 WHERE IdVehicule IN (1, 2);
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK;

    SELECT ERROR_NUMBER() AS NumeroErreur, ERROR_MESSAGE() AS MessageErreur;
END CATCH;

SELECT IdVehicule, Marque, Modele, Kilometrage, Statut FROM VEHICULE;
