-- TP3 - Exercice 6 : correction ensembliste du trigger
USE TP3;
GO

CREATE OR ALTER TRIGGER dbo.trg_ControleKilometrage
ON dbo.VEHICULE
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM deleted d
        INNER JOIN inserted i ON i.IdVehicule = d.IdVehicule
        WHERE i.Kilometrage < d.Kilometrage
    )
        THROW 50001, 'Le kilometrage ne peut pas diminuer.', 1;
END;
GO
