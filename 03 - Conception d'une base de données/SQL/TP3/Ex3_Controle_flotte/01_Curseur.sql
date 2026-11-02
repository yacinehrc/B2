-- TP3 - Exercice 3 : parcours de la flotte avec un curseur
USE TP3;
GO

DECLARE @IdVehicule INT;
DECLARE @Marque VARCHAR(50);
DECLARE @Modele VARCHAR(50);
DECLARE @Kilometrage INT;
DECLARE @Niveau VARCHAR(20);

DECLARE curseur_vehicules CURSOR FOR
    SELECT IdVehicule, Marque, Modele, Kilometrage
    FROM VEHICULE;

OPEN curseur_vehicules;

FETCH NEXT FROM curseur_vehicules
INTO @IdVehicule, @Marque, @Modele, @Kilometrage;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @Kilometrage < 20000
        SET @Niveau = 'NORMAL';
    ELSE IF @Kilometrage <= 50000
        SET @Niveau = 'SURVEILLANCE';
    ELSE
        SET @Niveau = 'PRIORITAIRE';

    PRINT CONCAT(@IdVehicule, ' - ', @Marque, ' ', @Modele, ' - ', @Kilometrage, ' km - ', @Niveau);

    FETCH NEXT FROM curseur_vehicules
    INTO @IdVehicule, @Marque, @Modele, @Kilometrage;
END;

CLOSE curseur_vehicules;
DEALLOCATE curseur_vehicules;
