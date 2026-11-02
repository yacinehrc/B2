-- TP2 - Exercice 2 : recherche multicritère (NULL = critère non appliqué)
USE TP2;
GO

CREATE OR ALTER PROCEDURE dbo.RechercherReparations
    @Statut VARCHAR(20) = NULL,
    @MontantMax DECIMAL(10,2) = NULL,
    @DateDepotMin DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdReparation, IdAppareil, IdTechnicien, DateDepot, Statut, Montant
    FROM REPARATION
    WHERE (@Statut IS NULL OR Statut = @Statut)
      AND (@MontantMax IS NULL OR Montant <= @MontantMax)
      AND (@DateDepotMin IS NULL OR DateDepot >= @DateDepotMin)
    ORDER BY DateDepot DESC;
END;
GO
