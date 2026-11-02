-- TP1 - Exercice 5 : version corrigée, cas nominal
USE TP1_Ex5;
GO

DECLARE @IdCommande INT = 101;
DECLARE @IdProduit INT = 1;
DECLARE @Quantite INT = 2;

BEGIN TRY

    BEGIN TRANSACTION;

    IF NOT EXISTS (
        SELECT 1
        FROM Commande
        WHERE IdCommande = @IdCommande
          AND Statut = 'BROUILLON'
    )
        THROW 50040, 'Commande inexistante ou non validable.', 1;

    IF NOT EXISTS (
        SELECT 1
        FROM Produit
        WHERE IdProduit = @IdProduit
          AND Stock >= @Quantite
    )
        THROW 50041, 'Stock insuffisant ou produit inexistant.', 1;

    UPDATE Commande
    SET Statut = 'VALIDEE'
    WHERE IdCommande = @IdCommande;

    UPDATE Produit
    SET Stock = Stock - @Quantite
    WHERE IdProduit = @IdProduit;

    INSERT INTO MouvementStock
    (
        IdProduit,
        Quantite,
        TypeMouvement,
        DateMouvement,
        IdCommande
    )
    VALUES
    (
        @IdProduit,
        @Quantite,
        'SORTIE',
        SYSDATETIME(),
        @IdCommande
    );

    COMMIT;

    PRINT 'Commande validée';

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
SELECT IdProduit, Quantite, TypeMouvement, IdCommande FROM MouvementStock;
