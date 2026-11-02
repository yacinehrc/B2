-- TP1 - Exercice 1 : validation réussie (un seul produit)
USE TP1_Ex1;
GO

DECLARE @IdCommande INT = 100;

BEGIN TRY

    BEGIN TRANSACTION;

    -- Vérification de l'existence et de l'état de la commande
    IF NOT EXISTS (
        SELECT 1
        FROM Commande
        WHERE IdCommande = @IdCommande
          AND Statut = 'BROUILLON'
    )
        THROW 50001, 'Commande inexistante ou non validable.', 1;

    -- Vérification globale des stocks
    IF EXISTS (
        SELECT 1
        FROM Ligne_Commande lc
        INNER JOIN Produit p
            ON p.IdProduit = lc.IdProduit
        WHERE lc.IdCommande = @IdCommande
          AND p.Stock < lc.Quantite
    )
        THROW 50002, 'Stock insuffisant pour au moins un produit.', 1;

    -- Mise à jour des stocks
    UPDATE p
    SET p.Stock = p.Stock - lc.Quantite
    FROM Produit p
    INNER JOIN Ligne_Commande lc
        ON lc.IdProduit = p.IdProduit
    WHERE lc.IdCommande = @IdCommande;

    -- Enregistrement des mouvements
    INSERT INTO Mouvement_Stock
    (
        IdProduit,
        DateMouvement,
        Quantite,
        TypeMouvement,
        IdCommande
    )
    SELECT
        lc.IdProduit,
        SYSDATETIME(),
        lc.Quantite,
        'SORTIE',
        lc.IdCommande
    FROM Ligne_Commande lc
    WHERE lc.IdCommande = @IdCommande;

    -- Validation de la commande
    UPDATE Commande
    SET Statut = 'VALIDEE'
    WHERE IdCommande = @IdCommande;

    COMMIT;

    PRINT 'Commande validée avec succès.';

END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK;

    SELECT
        ERROR_NUMBER() AS NumeroErreur,
        ERROR_MESSAGE() AS MessageErreur;

END CATCH;

SELECT IdCommande, Statut FROM Commande;
SELECT IdProduit, Libelle, Stock FROM Produit;
SELECT IdProduit, Quantite, TypeMouvement, IdCommande FROM Mouvement_Stock;
