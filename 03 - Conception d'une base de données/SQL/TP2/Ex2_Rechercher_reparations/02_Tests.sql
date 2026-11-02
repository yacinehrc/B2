-- TP2 - Exercice 2 : critères seuls puis combinés
USE TP2;
GO

EXEC dbo.RechercherReparations @Statut = 'TERMINEE';
EXEC dbo.RechercherReparations @MontantMax = 200;
EXEC dbo.RechercherReparations @DateDepotMin = '2026-10-01';
EXEC dbo.RechercherReparations @Statut = 'EN_COURS', @MontantMax = 300, @DateDepotMin = '2026-10-01';
