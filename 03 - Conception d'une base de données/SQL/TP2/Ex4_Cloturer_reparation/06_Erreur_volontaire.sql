-- TP2 - Exercice 4 : erreur provoquée après la modification du statut
USE TP2;
GO

-- Panne simulée : le paiement EN_ATTENTE ne peut plus être enregistré
ALTER TABLE PAIEMENT WITH NOCHECK
ADD CONSTRAINT CK_Panne_Test CHECK (Statut <> 'EN_ATTENTE');
GO

DECLARE @Montant DECIMAL(10,2);

BEGIN TRY
    EXEC dbo.CloturerReparation
        @IdReparation = 6,
        @Montant = @Montant OUTPUT;

    SELECT @Montant AS MontantReparation;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS NumeroErreur, ERROR_MESSAGE() AS MessageErreur;
END CATCH;

GO

ALTER TABLE PAIEMENT DROP CONSTRAINT CK_Panne_Test;
GO

SELECT IdReparation, Statut, Montant FROM REPARATION;
SELECT IdPaiement, IdReparation, Montant, Statut FROM PAIEMENT;
