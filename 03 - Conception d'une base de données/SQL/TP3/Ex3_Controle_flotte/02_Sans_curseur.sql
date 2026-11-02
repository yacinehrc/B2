-- TP3 - Exercice 3 : même résultat avec une requête classique
USE TP3;
GO

SELECT
    IdVehicule,
    Marque,
    Modele,
    Kilometrage,
    CASE
        WHEN Kilometrage < 20000 THEN 'NORMAL'
        WHEN Kilometrage <= 50000 THEN 'SURVEILLANCE'
        ELSE 'PRIORITAIRE'
    END AS Niveau
FROM VEHICULE;
