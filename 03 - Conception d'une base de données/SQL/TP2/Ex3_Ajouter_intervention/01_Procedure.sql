-- TP2 - Exercice 3 : ajout d'une intervention
USE TP2;
GO

-- Une seule modification (un INSERT) : pas besoin de transaction explicite
CREATE OR ALTER PROCEDURE dbo.AjouterIntervention
    @IdReparation INT,
    @Description VARCHAR(255),
    @DureeMinutes INT,
    @IdIntervention INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Statut VARCHAR(20);

    SELECT @Statut = Statut
    FROM REPARATION
    WHERE IdReparation = @IdReparation;

    IF @Statut IS NULL
        THROW 50110, 'Réparation inexistante.', 1;

    IF @Statut IN ('TERMINEE', 'ANNULEE')
        THROW 50111, 'Cette réparation ne peut plus recevoir d''intervention.', 1;

    INSERT INTO INTERVENTION (IdReparation, DateIntervention, Description, DureeMinutes)
    VALUES (@IdReparation, GETDATE(), @Description, @DureeMinutes);

    SET @IdIntervention = SCOPE_IDENTITY();
END;
GO
