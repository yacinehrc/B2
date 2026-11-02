-- TP3 - Exercice 5 : le kilométrage ne doit jamais diminuer
USE TP3;
GO

CREATE OR ALTER TRIGGER dbo.trg_Vehicule_KilometrageCroissant
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
        THROW 50200, 'Le kilométrage ne peut pas diminuer.', 1;
END;
GO
