-- TP3 - Exercice 2 : fonction table et recherches (NULL = critère non appliqué)
USE TP3;
GO

CREATE OR ALTER FUNCTION dbo.fn_RechercherVehicules
(
    @Categorie VARCHAR(30),
    @PrixMax DECIMAL(10,2),
    @Statut VARCHAR(20)
)
RETURNS TABLE
AS
RETURN
(
    SELECT IdVehicule, Marque, Modele, Categorie, PrixJour, Kilometrage, Statut
    FROM VEHICULE
    WHERE (@Categorie IS NULL OR Categorie = @Categorie)
      AND (@PrixMax IS NULL OR PrixJour <= @PrixMax)
      AND (@Statut IS NULL OR Statut = @Statut)
);
GO

SELECT * FROM dbo.fn_RechercherVehicules(NULL, NULL, 'DISPONIBLE');
SELECT * FROM dbo.fn_RechercherVehicules('SUV', NULL, 'DISPONIBLE');
SELECT * FROM dbo.fn_RechercherVehicules(NULL, 80, 'DISPONIBLE');
SELECT * FROM dbo.fn_RechercherVehicules('Citadine', 80, 'DISPONIBLE');
