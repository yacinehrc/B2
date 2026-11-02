-- TP2 : insertion des données de test
USE TP2;
GO

INSERT INTO CLIENT VALUES
(1, 'Martin', 'martin@email.fr'),
(2, 'Durand', 'durand@email.fr'),
(3, 'Bernard', 'bernard@email.fr');

INSERT INTO APPAREIL VALUES
(1, 1, 'PC', 'Dell', 'OptiPlex 7010'),
(2, 1, 'Smartphone', 'Samsung', 'Galaxy S23'),
(3, 2, 'Ordinateur portable', 'HP', 'ProBook 450'),
(4, 3, 'PC', 'Lenovo', 'ThinkCentre M70'),
(5, 3, 'Smartphone', 'Apple', 'iPhone 14');

-- Le technicien 3 n'a aucune réparation
INSERT INTO TECHNICIEN VALUES
(1, 'Lefevre', 'Matériel'),
(2, 'Petit', 'Logiciel'),
(3, 'Roux', 'Réseau');

INSERT INTO REPARATION VALUES
(1, 1, 1, '2026-09-01', 'TERMINEE', 120.00),
(2, 2, 1, '2026-09-20', 'EN_COURS', 80.00),
(3, 3, 1, '2026-10-05', 'EN_COURS', 250.00),
(4, 4, 2, '2026-10-01', 'EN_ATTENTE', 60.00),
(5, 5, 2, '2026-09-15', 'ANNULEE', 150.00),
(6, 3, 2, '2026-10-10', 'EN_COURS', 350.00);

INSERT INTO INTERVENTION (IdReparation, DateIntervention, Description, DureeMinutes) VALUES
(1, '2026-09-02T10:00:00', 'Remplacement du disque dur', 60),
(2, '2026-09-21T14:30:00', 'Diagnostic de l''écran', 30),
(3, '2026-10-06T09:15:00', 'Nettoyage et changement de pâte thermique', 45);

INSERT INTO PAIEMENT (IdReparation, DatePaiement, Montant, Statut) VALUES
(1, '2026-09-03', 120.00, 'VALIDE'),
(2, '2026-09-21', 80.00, 'EN_ATTENTE');

SELECT IdReparation, Statut, Montant FROM REPARATION;
SELECT IdIntervention, IdReparation, Description, DureeMinutes FROM INTERVENTION;
SELECT IdPaiement, IdReparation, Montant, Statut FROM PAIEMENT;
