-- TP1 - Exercice 4 : erreur volontaire pendant le traitement
USE TP1_Ex4;
GO

DECLARE @DateCloture DATE = '2026-09-17';

BEGIN TRY

    BEGIN TRANSACTION;

    DECLARE @NombreCommandes INT;
    DECLARE @MontantTotal DECIMAL(12,2);

    -- Recherche des commandes présentant une anomalie
    IF EXISTS
    (
        SELECT 1
        FROM Commande c
        INNER JOIN Paiement p
            ON p.IdCommande = c.IdCommande
        WHERE c.DateCommande = @DateCloture
        GROUP BY c.IdCommande, c.Montant
        HAVING SUM(
            CASE
                WHEN p.Statut = 'VALIDE'
                THEN p.Montant
                ELSE 0
            END
        ) <> c.Montant
    )
        THROW 50030, 'Au moins une commande présente une anomalie de paiement.', 1;

    -- Passage des commandes à l'état clôturé
    UPDATE Commande
    SET Statut = 'CLOTUREE'
    WHERE DateCommande = @DateCloture
      AND Statut = 'EN_ATTENTE';

    -- Erreur volontaire : les commandes viennent de passer à CLOTUREE
    THROW 50099, 'Erreur volontaire pendant la clôture.', 1;

    SELECT
        @NombreCommandes = COUNT(*),
        @MontantTotal = COALESCE(SUM(Montant), 0)
    FROM Commande
    WHERE DateCommande = @DateCloture
      AND Statut = 'CLOTUREE';

    INSERT INTO Journal_Cloture
    (
        DateCloture,
        NombreCommandes,
        MontantTotal,
        DateTraitement
    )
    VALUES
    (
        @DateCloture,
        @NombreCommandes,
        @MontantTotal,
        SYSDATETIME()
    );

    COMMIT;

    SELECT
        'CLOTUREE' AS Resultat,
        @NombreCommandes AS NombreCommandes,
        @MontantTotal AS MontantTotal;

END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK;

    SELECT
        'ECHEC' AS Resultat,
        ERROR_NUMBER() AS NumeroErreur,
        ERROR_MESSAGE() AS MessageErreur;

END CATCH;

SELECT IdCommande, DateCommande, Statut, Montant FROM Commande WHERE DateCommande = @DateCloture;
SELECT DateCloture, NombreCommandes, MontantTotal FROM Journal_Cloture;
