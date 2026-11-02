-- TP2 - Exercice 5 : procédure corrigée, même panne
USE TP2;
GO

-- Panne simulée : le paiement EN_ATTENTE ne peut plus être enregistré
ALTER TABLE PAIEMENT WITH NOCHECK
ADD CONSTRAINT CK_Panne_Test CHECK (Statut <> 'EN_ATTENTE');
GO

BEGIN TRY
    EXEC dbo.TerminerReparation @IdReparation = 6;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS NumeroErreur, ERROR_MESSAGE() AS MessageErreur;
END CATCH;
GO

ALTER TABLE PAIEMENT DROP CONSTRAINT CK_Panne_Test;
GO

SELECT IdReparation, Statut, Montant FROM REPARATION;
SELECT IdPaiement, IdReparation, Montant, Statut FROM PAIEMENT;
