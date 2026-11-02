-- TP2 - Exercice 4 : clôture d'une réparation
USE TP2;
GO

-- Le statut et le paiement forment une seule opération métier : tout est dans la même transaction
CREATE OR ALTER PROCEDURE dbo.CloturerReparation
    @IdReparation INT,
    @Montant DECIMAL(10,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Statut VARCHAR(20);

    BEGIN TRY

        BEGIN TRANSACTION;

        SELECT @Statut = Statut, @Montant = Montant
        FROM REPARATION
        WHERE IdReparation = @IdReparation;

        IF @Statut IS NULL
            THROW 50120, 'Réparation inexistante.', 1;

        IF @Statut = 'TERMINEE'
            THROW 50121, 'Réparation déjà terminée.', 1;

        IF @Statut = 'ANNULEE'
            THROW 50122, 'Réparation annulée.', 1;

        UPDATE REPARATION
        SET Statut = 'TERMINEE'
        WHERE IdReparation = @IdReparation;

        -- Un paiement est créé seulement si la réparation n'en a pas déjà un en cours
        IF NOT EXISTS (
            SELECT 1
            FROM PAIEMENT
            WHERE IdReparation = @IdReparation
              AND Statut <> 'REFUSE'
        )
            INSERT INTO PAIEMENT (IdReparation, DatePaiement, Montant, Statut)
            VALUES (@IdReparation, GETDATE(), @Montant, 'EN_ATTENTE');

        COMMIT;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK;

        THROW;

    END CATCH;
END;
GO
