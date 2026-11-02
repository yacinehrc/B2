-- TP1 - Exercice 3 : client inexistant
USE TP1_Ex3;
GO

DECLARE @IdClient INT = 999;
DECLARE @NouvelleAgence INT = 2;

BEGIN TRY

    BEGIN TRANSACTION;

    DECLARE @AncienneAgence INT;

    SELECT @AncienneAgence = IdAgence
    FROM Client
    WHERE IdClient = @IdClient;

    IF @AncienneAgence IS NULL
        THROW 50020, 'Client inexistant.', 1;

    IF NOT EXISTS (
        SELECT 1
        FROM Agence
        WHERE IdAgence = @NouvelleAgence
    )
        THROW 50021, 'Agence destination inexistante.', 1;

    IF @AncienneAgence = @NouvelleAgence
        THROW 50022, 'Le client est déjà rattaché à cette agence.', 1;

    UPDATE Historique_Affectation
    SET DateFin = CAST(GETDATE() AS DATE)
    WHERE IdClient = @IdClient
      AND DateFin IS NULL;

    INSERT INTO Historique_Affectation
    (
        IdClient,
        IdAgence,
        DateDebut,
        DateFin
    )
    VALUES
    (
        @IdClient,
        @NouvelleAgence,
        CAST(GETDATE() AS DATE),
        NULL
    );

    UPDATE Client
    SET IdAgence = @NouvelleAgence
    WHERE IdClient = @IdClient;

    COMMIT;

    PRINT 'Transfert réalisé avec succès.';

END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK;

    SELECT
        ERROR_NUMBER() AS NumeroErreur,
        ERROR_MESSAGE() AS MessageErreur;

END CATCH;

SELECT IdClient, Nom, IdAgence FROM Client;
SELECT IdAffectation, IdClient, IdAgence, DateDebut, DateFin FROM Historique_Affectation;
