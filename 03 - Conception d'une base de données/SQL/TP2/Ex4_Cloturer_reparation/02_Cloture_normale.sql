-- TP2 - Exercice 4 : clôture normale
USE TP2;
GO

DECLARE @Montant DECIMAL(10,2);

BEGIN TRY
    EXEC dbo.CloturerReparation
        @IdReparation = 3,
        @Montant = @Montant OUTPUT;

    SELECT @Montant AS MontantReparation;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS NumeroErreur, ERROR_MESSAGE() AS MessageErreur;
END CATCH;

SELECT IdReparation, Statut, Montant FROM REPARATION;
SELECT IdPaiement, IdReparation, Montant, Statut FROM PAIEMENT;
