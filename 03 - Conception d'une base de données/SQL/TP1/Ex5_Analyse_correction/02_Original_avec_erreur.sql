-- TP1 - Exercice 5 : traitement original, l'INSERT échoue après les deux UPDATE
USE TP1_Ex5;
GO

-- Panne simulée : le mouvement de type SORTIE ne peut plus être enregistré
ALTER TABLE MouvementStock
ADD CONSTRAINT CK_Panne_Test CHECK (TypeMouvement <> 'SORTIE');
GO

DECLARE @IdCommande INT = 100;
DECLARE @IdProduit INT = 1;
DECLARE @Quantite INT = 2;

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
    GETDATE(),
    @IdCommande
);

PRINT 'Commande validée';
GO

ALTER TABLE MouvementStock DROP CONSTRAINT CK_Panne_Test;
GO

SELECT IdCommande, Statut FROM Commande;
SELECT IdProduit, Libelle, Stock FROM Produit;
SELECT IdProduit, Quantite, TypeMouvement, IdCommande FROM MouvementStock;
