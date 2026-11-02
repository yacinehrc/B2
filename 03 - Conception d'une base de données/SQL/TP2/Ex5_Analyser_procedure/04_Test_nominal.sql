-- TP2 - Exercice 5 : procédure corrigée, cas nominal puis second appel refusé
USE TP2;
GO

BEGIN TRY
    EXEC dbo.TerminerReparation @IdReparation = 6;
    EXEC dbo.TerminerReparation @IdReparation = 6;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS NumeroErreur, ERROR_MESSAGE() AS MessageErreur;
END CATCH;

SELECT IdReparation, Statut, Montant FROM REPARATION;
SELECT IdPaiement, IdReparation, Montant, Statut FROM PAIEMENT;
