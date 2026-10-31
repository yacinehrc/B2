-- Données de démo chargées après 01_schema.sql
-- Comptes a_mar, b_dup, c_ber et d_ler, tous avec le mot de passe "motdepasse"

SET NAMES utf8mb4;

-- Hash bcrypt de "motdepasse"
INSERT INTO utilisateur (id, identifiant, prenom, nom, mot_de_passe, bio, avatar, cree_le) VALUES
(1, 'a_mar', 'Alice', 'Martin',  '$2y$12$Ivgg8MbRXIjyQeSN4FtC5u6JCMxkviTariMQKZCF3flQgZ4r.V/zu', 'Fan de Symfony et de jeux vidéo 🎮', NULL, NOW() - INTERVAL 10 DAY),
(2, 'b_dup', 'Bob',   'Dupont',  '$2y$12$Ivgg8MbRXIjyQeSN4FtC5u6JCMxkviTariMQKZCF3flQgZ4r.V/zu', NULL, NULL, NOW() - INTERVAL 9 DAY),
(3, 'c_ber', 'Chloé', 'Bernard', '$2y$12$Ivgg8MbRXIjyQeSN4FtC5u6JCMxkviTariMQKZCF3flQgZ4r.V/zu', 'Étudiante en développement web', NULL, NOW() - INTERVAL 8 DAY),
(4, 'd_ler', 'David', 'Leroy',   '$2y$12$Ivgg8MbRXIjyQeSN4FtC5u6JCMxkviTariMQKZCF3flQgZ4r.V/zu', NULL, NULL, NOW() - INTERVAL 2 DAY);

-- Amitiés : Alice, Bob et Chloé sont amis entre eux ; David attend la réponse d'Alice
INSERT INTO contact (id, statut, cree_le, demandeur_id, destinataire_id) VALUES
(1, 'accepte',    NOW() - INTERVAL 8 DAY, 1, 2),
(2, 'accepte',    NOW() - INTERVAL 7 DAY, 1, 3),
(3, 'accepte',    NOW() - INTERVAL 7 DAY, 2, 3),
(4, 'en_attente', NOW() - INTERVAL 1 DAY, 4, 1);

-- Discussions : un MP Alice <-> Bob et un groupe à 3
INSERT INTO discussion (id, nom, cree_le) VALUES
(1, NULL,             NOW() - INTERVAL 6 DAY),
(2, 'Projet Symfony', NOW() - INTERVAL 5 DAY);

INSERT INTO discussion_utilisateur (discussion_id, utilisateur_id) VALUES
(1, 1), (1, 2),
(2, 1), (2, 2), (2, 3);

-- Un serveur "Gaming" créé par Alice, avec 2 salons
INSERT INTO serveur (id, nom, cree_le, proprietaire_id) VALUES
(1, 'Gaming', NOW() - INTERVAL 4 DAY, 1);

INSERT INTO serveur_utilisateur (serveur_id, utilisateur_id) VALUES
(1, 1), (1, 2), (1, 3);

INSERT INTO salon (id, nom, serveur_id) VALUES
(1, 'général', 1),
(2, 'jeux',    1);

-- Quelques messages
INSERT INTO message (contenu, cree_le, modifie_le, auteur_id, discussion_id, salon_id) VALUES
('Salut Bob, ça va ?',                                   NOW() - INTERVAL 3 HOUR,  NULL, 1, 1, NULL),
('Salut Alice ! Oui et toi ?',                           NOW() - INTERVAL 170 MINUTE, NULL, 2, 1, NULL),
('Super, je teste Y - Messages 😄',                       NOW() - INTERVAL 160 MINUTE, NULL, 1, 1, NULL),
('Bienvenue dans le groupe du projet !',                 NOW() - INTERVAL 2 DAY,   NULL, 1, 2, NULL),
('Qui s\'occupe des entités Doctrine ?',                 NOW() - INTERVAL 2 DAY,   NULL, 3, 2, NULL),
('Moi, je fais aussi les contrôleurs',                   NOW() - INTERVAL 1 DAY,   NOW() - INTERVAL 1 DAY, 2, 2, NULL),
('Bienvenue sur le serveur Gaming 🎉',                    NOW() - INTERVAL 4 DAY,   NULL, 1, NULL, 1),
('Merci Alice !',                                        NOW() - INTERVAL 4 DAY,   NULL, 3, NULL, 1),
('Quelqu\'un pour une partie ce soir ?',                 NOW() - INTERVAL 5 HOUR,  NULL, 2, NULL, 2);
