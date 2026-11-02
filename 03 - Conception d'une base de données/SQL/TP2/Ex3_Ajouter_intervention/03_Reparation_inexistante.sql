-- TP2 - Exercice 3 : réparation inexistante
USE TP2;
GO

DECLARE @IdIntervention INT;

BEGIN TRY
    EXEC dbo.AjouterIntervention
        @IdReparation = 999,
        @Description = 'Test',
        @DureeMinutes = 30,
        @IdIntervention = @IdIntervention OUTPUT;

    SELECT @IdIntervention AS IdInterventionCreee;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS NumeroErreur, ERROR_MESSAGE() AS MessageErreur;
END CATCH;

SELECT IdIntervention, IdReparation, Description, DureeMinutes FROM INTERVENTION;
