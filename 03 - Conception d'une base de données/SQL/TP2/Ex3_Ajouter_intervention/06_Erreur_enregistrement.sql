-- TP2 - Exercice 3 : erreur lors de l'enregistrement (description NULL)
USE TP2;
GO

DECLARE @IdIntervention INT;

BEGIN TRY
    EXEC dbo.AjouterIntervention
        @IdReparation = 3,
        @Description = NULL,
        @DureeMinutes = 30,
        @IdIntervention = @IdIntervention OUTPUT;

    SELECT @IdIntervention AS IdInterventionCreee;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS NumeroErreur, ERROR_MESSAGE() AS MessageErreur;
END CATCH;

SELECT IdIntervention, IdReparation, Description, DureeMinutes FROM INTERVENTION;
