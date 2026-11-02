-- TP3 - Exercice 6 : correction testée sur une seule ligne
USE TP3;
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
