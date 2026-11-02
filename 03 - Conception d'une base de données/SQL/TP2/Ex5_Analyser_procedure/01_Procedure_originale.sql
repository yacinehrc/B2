-- TP2 - Exercice 5 : procédure du développeur, le paiement échoue après l'UPDATE
USE TP2;
GO

CREATE OR ALTER PROCEDURE dbo.TerminerReparation
    @IdReparation INT
AS
BEGIN
    SET NOCOUNT ON;

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

    PRINT 'Réparation terminée';
END;
GO

-- Panne simulée : le paiement EN_ATTENTE ne peut plus être enregistré
ALTER TABLE PAIEMENT WITH NOCHECK
ADD CONSTRAINT CK_Panne_Test CHECK (Statut <> 'EN_ATTENTE');
GO

EXEC dbo.TerminerReparation @IdReparation = 4;
GO

ALTER TABLE PAIEMENT DROP CONSTRAINT CK_Panne_Test;
GO

SELECT IdReparation, Statut, Montant FROM REPARATION;
SELECT IdPaiement, IdReparation, Montant, Statut FROM PAIEMENT;
