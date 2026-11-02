-- TP3 - Exercice 1 : fonction scalaire et tests sur plusieurs durées
USE TP3;
GO

CREATE OR ALTER FUNCTION dbo.fn_CalculPrixLocation
(
    @PrixJour DECIMAL(10,2),
    @DateDebut DATE,
    @DateFin DATE
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @NbJours INT = DATEDIFF(DAY, @DateDebut, @DateFin);

    -- Un véhicule rendu le jour même est facturé une journée
    IF @NbJours <= 0
        SET @NbJours = 1;

    RETURN @PrixJour * @NbJours;
END;
GO

SELECT
    dbo.fn_CalculPrixLocation(50, '2026-10-10', '2026-10-13') AS Trois_jours,
    dbo.fn_CalculPrixLocation(50, '2026-10-10', '2026-10-11') AS Un_jour,
    dbo.fn_CalculPrixLocation(50, '2026-10-10', '2026-10-10') AS Meme_jour,
    dbo.fn_CalculPrixLocation(50, '2026-10-01', '2026-10-31') AS Trente_jours;
