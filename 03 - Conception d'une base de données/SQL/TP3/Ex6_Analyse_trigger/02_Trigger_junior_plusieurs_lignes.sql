-- TP3 - Exercice 6 : trigger du junior, l'anomalie du véhicule 2 passe inaperçue
USE TP3;
GO

-- La transaction est annulée à la fin pour remettre les données en état
BEGIN TRANSACTION;

BEGIN TRY
    UPDATE VEHICULE
    SET Kilometrage = CASE WHEN IdVehicule = 2 THEN 1000 ELSE Kilometrage + 100 END
    WHERE IdVehicule IN (1, 2);

    SELECT 'Aucune erreur levée' AS Resultat;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK;

    SELECT ERROR_NUMBER() AS NumeroErreur, ERROR_MESSAGE() AS MessageErreur;
END CATCH;

SELECT IdVehicule, Marque, Modele, Kilometrage, Statut FROM VEHICULE WHERE IdVehicule IN (1, 2);

IF @@TRANCOUNT > 0
    ROLLBACK;
