-- TP1 - Exercice 2 : donnée incorrecte (date de fin avant la date de début)
USE TP1_Ex2;
GO

BEGIN TRY

    BEGIN TRANSACTION;

    INSERT INTO Reservation VALUES
    (103, 1, 3, '2026-10-10', '2026-10-05', 'EN_ATTENTE', 100.00);

    COMMIT;

END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK;

    SELECT
        ERROR_NUMBER() AS NumeroErreur,
        ERROR_MESSAGE() AS MessageErreur;

END CATCH;

SELECT IdReservation, IdVehicule, Statut, Montant FROM Reservation;
SELECT IdVehicule, Immatriculation, Statut FROM Vehicule;
SELECT IdReservation, Montant, Statut FROM Paiement;
SELECT IdVehicule, Evenement, IdReservation FROM Historique_Vehicule;
