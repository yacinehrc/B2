-- TP2 - Exercice 1 : plusieurs réparations, aucune réparation, technicien inexistant
USE TP2;
GO

EXEC dbo.ListerReparationsTechnicien @IdTechnicien = 1;
EXEC dbo.ListerReparationsTechnicien @IdTechnicien = 3;

BEGIN TRY
    EXEC dbo.ListerReparationsTechnicien @IdTechnicien = 99;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS NumeroErreur, ERROR_MESSAGE() AS MessageErreur;
END CATCH;
