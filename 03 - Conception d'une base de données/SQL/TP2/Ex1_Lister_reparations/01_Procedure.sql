-- TP2 - Exercice 1 : réparations d'un technicien
USE TP2;
GO

CREATE OR ALTER PROCEDURE dbo.ListerReparationsTechnicien
    @IdTechnicien INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM TECHNICIEN WHERE IdTechnicien = @IdTechnicien)
        THROW 50100, 'Technicien inexistant.', 1;

    SELECT
        r.IdReparation,
        c.Nom AS Client,
        a.TypeAppareil,
        a.Marque,
        a.Modele,
        r.Statut,
        r.Montant,
        r.DateDepot
    FROM REPARATION r
    INNER JOIN APPAREIL a ON a.IdAppareil = r.IdAppareil
    INNER JOIN CLIENT c ON c.IdClient = a.IdClient
    WHERE r.IdTechnicien = @IdTechnicien
    ORDER BY r.DateDepot DESC;
END;
GO
