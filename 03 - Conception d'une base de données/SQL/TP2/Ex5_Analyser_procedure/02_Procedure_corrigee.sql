-- TP2 - Exercice 5 : procédure corrigée (contrôles + transaction)
USE TP2;
GO

CREATE OR ALTER PROCEDURE dbo.TerminerReparation
    @IdReparation INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Statut VARCHAR(20);

    BEGIN TRY

        BEGIN TRANSACTION;

        SELECT @Statut = Statut
        FROM REPARATION
        WHERE IdReparation = @IdReparation;

        IF @Statut IS NULL
            THROW 50130, 'Réparation inexistante.', 1;

        IF @Statut IN ('TERMINEE', 'ANNULEE')
            THROW 50131, 'Cette réparation ne peut pas être terminée.', 1;

        UPDATE REPARATION
        SET Statut = 'TERMINEE'
        WHERE IdReparation = @IdReparation;

        INSERT INTO PAIEMENT
        (
            IdReparation,
            DatePaiement,
            Montant,
            Statut
        )
        SELECT
            IdReparation,
            GETDATE(),
            Montant,
            'EN_ATTENTE'
        FROM REPARATION
        WHERE IdReparation = @IdReparation;

        COMMIT;

        PRINT 'Réparation terminée';

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK;

        THROW;

    END CATCH;
END;
GO
