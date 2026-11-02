-- TP3 - Exercice 1 : prix calculé et prix enregistré
USE TP3;
GO

SELECT
    l.IdLocation,
    l.DateDebut,
    l.DateFin,
    v.PrixJour,
    dbo.fn_CalculPrixLocation(v.PrixJour, l.DateDebut, l.DateFin) AS PrixCalcule,
    l.PrixTotal AS PrixEnregistre,
    l.PrixTotal - dbo.fn_CalculPrixLocation(v.PrixJour, l.DateDebut, l.DateFin) AS Ecart
FROM LOCATION l
INNER JOIN VEHICULE v ON v.IdVehicule = l.IdVehicule;
