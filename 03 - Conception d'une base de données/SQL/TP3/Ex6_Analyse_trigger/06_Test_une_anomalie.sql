-- TP3 - Exercice 6 : plusieurs lignes dont une seule présente une anomalie
USE TP3;
GO

BEGIN TRY
    UPDATE VEHICULE
    SET Kilometrage = CASE WHEN IdVehicule = 2 THEN 1000 ELSE Kilometrage + 100 END
    WHERE IdVehicule IN (1, 2);
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK;

    SELECT ERROR_NUMBER() AS NumeroErreur, ERROR_MESSAGE() AS MessageErreur;
END CATCH;

SELECT IdVehicule, Marque, Modele, Kilometrage, Statut FROM VEHICULE;
