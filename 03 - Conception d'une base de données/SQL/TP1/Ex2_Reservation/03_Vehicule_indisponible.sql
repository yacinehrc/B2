-- TP1 - Exercice 2 : véhicule en entretien, réservation impossible
USE TP1_Ex2;
GO

DECLARE @IdReservation INT = 101;

BEGIN TRY

    BEGIN TRANSACTION;

    DECLARE @IdVehicule INT;
    DECLARE @Montant DECIMAL(10,2);

    SELECT
        @IdVehicule = IdVehicule,
        @Montant = Montant
    FROM Reservation
    WHERE IdReservation = @IdReservation
      AND Statut = 'EN_ATTENTE';

    IF @IdVehicule IS NULL
        THROW 50010, 'Réservation inexistante ou non confirmable.', 1;

    IF NOT EXISTS (
        SELECT 1
        FROM Vehicule
        WHERE IdVehicule = @IdVehicule
          AND Statut = 'DISPONIBLE'
    )
        THROW 50011, 'Le véhicule n''est pas disponible.', 1;

    UPDATE Reservation
    SET Statut = 'CONFIRMEE'
    WHERE IdReservation = @IdReservation;

    UPDATE Vehicule
    SET Statut = 'RESERVE'
    WHERE IdVehicule = @IdVehicule;

    INSERT INTO Paiement
    (
        IdReservation,
        DatePaiement,
        Montant,
        Statut
    )
    VALUES
    (
        @IdReservation,
        SYSDATETIME(),
        @Montant,
        'EN_ATTENTE'
    );

    INSERT INTO Historique_Vehicule
    (
        IdVehicule,
        DateEvenement,
        Evenement,
        IdReservation
    )
    VALUES
    (
        @IdVehicule,
        SYSDATETIME(),
        'Véhicule réservé',
        @IdReservation
    );

    COMMIT;

    PRINT 'Réservation confirmée.';

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
