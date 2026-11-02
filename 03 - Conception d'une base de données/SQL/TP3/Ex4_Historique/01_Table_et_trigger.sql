-- TP3 - Exercice 4 : table d'historique et trigger
USE TP3;
GO

CREATE TABLE HISTORIQUE_VEHICULE (
    IdHistorique INT IDENTITY PRIMARY KEY,
    IdVehicule INT NOT NULL,
    DateModification DATETIME2 NOT NULL,
    AncienStatut VARCHAR(20) NOT NULL,
    NouveauStatut VARCHAR(20) NOT NULL,
    AncienKilometrage INT NOT NULL,
    NouveauKilometrage INT NOT NULL,
    FOREIGN KEY (IdVehicule) REFERENCES VEHICULE(IdVehicule)
);
GO

CREATE OR ALTER TRIGGER dbo.trg_Vehicule_Historique
ON dbo.VEHICULE
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO HISTORIQUE_VEHICULE
    (
        IdVehicule,
        DateModification,
        AncienStatut,
        NouveauStatut,
        AncienKilometrage,
        NouveauKilometrage
    )
    SELECT
        d.IdVehicule,
        SYSDATETIME(),
        d.Statut,
        i.Statut,
        d.Kilometrage,
        i.Kilometrage
    FROM deleted d
    INNER JOIN inserted i ON i.IdVehicule = d.IdVehicule
    WHERE d.Statut <> i.Statut
       OR d.Kilometrage <> i.Kilometrage;
END;
GO
