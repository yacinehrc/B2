-- Création des tables, exécuté automatiquement par Docker au premier lancement (identique aux entités)

SET NAMES utf8mb4;

CREATE TABLE utilisateur (
    id           INT AUTO_INCREMENT NOT NULL,
    identifiant  VARCHAR(50)  NOT NULL,
    prenom       VARCHAR(100) NOT NULL,
    nom          VARCHAR(100) NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,      -- hash bcrypt, jamais le mot de passe en clair
    bio          LONGTEXT     DEFAULT NULL,
    avatar       VARCHAR(255) DEFAULT NULL,  -- nom du fichier dans public/uploads/avatars
    cree_le      DATETIME     NOT NULL,
    UNIQUE INDEX UNIQ_1D1C63B3C90409EC (identifiant),
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8mb4;

-- statut : 'en_attente' tant que la demande n'est pas acceptée, puis 'accepte'
CREATE TABLE contact (
    id              INT AUTO_INCREMENT NOT NULL,
    statut          VARCHAR(20) NOT NULL,
    cree_le         DATETIME    NOT NULL,
    demandeur_id    INT NOT NULL,
    destinataire_id INT NOT NULL,
    INDEX IDX_4C62E63895A6EE59 (demandeur_id),
    INDEX IDX_4C62E638A4F84F6E (destinataire_id),
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8mb4;

-- nom à NULL pour un MP, rempli pour un groupe
CREATE TABLE discussion (
    id      INT AUTO_INCREMENT NOT NULL,
    nom     VARCHAR(100) DEFAULT NULL,
    cree_le DATETIME     NOT NULL,
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8mb4;

-- Table de liaison : membres de chaque discussion
CREATE TABLE discussion_utilisateur (
    discussion_id  INT NOT NULL,
    utilisateur_id INT NOT NULL,
    INDEX IDX_99FB46E1ADED311 (discussion_id),
    INDEX IDX_99FB46EFB88E14F (utilisateur_id),
    PRIMARY KEY (discussion_id, utilisateur_id)
) DEFAULT CHARACTER SET utf8mb4;

CREATE TABLE serveur (
    id              INT AUTO_INCREMENT NOT NULL,
    nom             VARCHAR(100) NOT NULL,
    cree_le         DATETIME     NOT NULL,
    proprietaire_id INT NOT NULL,
    INDEX IDX_77CC53A676C50E4A (proprietaire_id),
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8mb4;

-- Table de liaison : membres de chaque serveur
CREATE TABLE serveur_utilisateur (
    serveur_id     INT NOT NULL,
    utilisateur_id INT NOT NULL,
    INDEX IDX_C3773BA3B8F06499 (serveur_id),
    INDEX IDX_C3773BA3FB88E14F (utilisateur_id),
    PRIMARY KEY (serveur_id, utilisateur_id)
) DEFAULT CHARACTER SET utf8mb4;

CREATE TABLE salon (
    id         INT AUTO_INCREMENT NOT NULL,
    nom        VARCHAR(100) NOT NULL,
    serveur_id INT NOT NULL,
    INDEX IDX_F268F417B8F06499 (serveur_id),
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8mb4;

-- Soit discussion_id, soit salon_id est rempli, jamais les deux
CREATE TABLE message (
    id            INT AUTO_INCREMENT NOT NULL,
    contenu       LONGTEXT NOT NULL,
    cree_le       DATETIME NOT NULL,
    modifie_le    DATETIME DEFAULT NULL,
    auteur_id     INT NOT NULL,
    discussion_id INT DEFAULT NULL,
    salon_id      INT DEFAULT NULL,
    INDEX IDX_B6BD307F60BB6FE6 (auteur_id),
    INDEX IDX_B6BD307F1ADED311 (discussion_id),
    INDEX IDX_B6BD307F4C91BDE4 (salon_id),
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8mb4;

-- Clés étrangères : ON DELETE CASCADE supprime aussi les lignes liées (un salon emporte ses messages)
ALTER TABLE contact ADD CONSTRAINT FK_4C62E63895A6EE59 FOREIGN KEY (demandeur_id) REFERENCES utilisateur (id) ON DELETE CASCADE;
ALTER TABLE contact ADD CONSTRAINT FK_4C62E638A4F84F6E FOREIGN KEY (destinataire_id) REFERENCES utilisateur (id) ON DELETE CASCADE;
ALTER TABLE discussion_utilisateur ADD CONSTRAINT FK_99FB46E1ADED311 FOREIGN KEY (discussion_id) REFERENCES discussion (id) ON DELETE CASCADE;
ALTER TABLE discussion_utilisateur ADD CONSTRAINT FK_99FB46EFB88E14F FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id) ON DELETE CASCADE;
ALTER TABLE message ADD CONSTRAINT FK_B6BD307F60BB6FE6 FOREIGN KEY (auteur_id) REFERENCES utilisateur (id) ON DELETE CASCADE;
ALTER TABLE message ADD CONSTRAINT FK_B6BD307F1ADED311 FOREIGN KEY (discussion_id) REFERENCES discussion (id) ON DELETE CASCADE;
ALTER TABLE message ADD CONSTRAINT FK_B6BD307F4C91BDE4 FOREIGN KEY (salon_id) REFERENCES salon (id) ON DELETE CASCADE;
ALTER TABLE salon ADD CONSTRAINT FK_F268F417B8F06499 FOREIGN KEY (serveur_id) REFERENCES serveur (id) ON DELETE CASCADE;
ALTER TABLE serveur ADD CONSTRAINT FK_77CC53A676C50E4A FOREIGN KEY (proprietaire_id) REFERENCES utilisateur (id) ON DELETE CASCADE;
ALTER TABLE serveur_utilisateur ADD CONSTRAINT FK_C3773BA3B8F06499 FOREIGN KEY (serveur_id) REFERENCES serveur (id) ON DELETE CASCADE;
ALTER TABLE serveur_utilisateur ADD CONSTRAINT FK_C3773BA3FB88E14F FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id) ON DELETE CASCADE;
