<?php

declare(strict_types=1);

namespace App\Migrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

// Crée les tables, pour une installation sans Docker (identique à database/01_schema.sql)
final class Version20261103181015 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Création des tables de Y - Messages';
    }

    public function up(Schema $schema): void
    {
        // Avec Docker les tables existent déjà : on passe au lieu de planter
        $this->skipIf($schema->hasTable('utilisateur'), 'Les tables existent déjà (créées par database/01_schema.sql).');

        $this->addSql('CREATE TABLE contact (id INT AUTO_INCREMENT NOT NULL, statut VARCHAR(20) NOT NULL, cree_le DATETIME NOT NULL, demandeur_id INT NOT NULL, destinataire_id INT NOT NULL, INDEX IDX_4C62E63895A6EE59 (demandeur_id), INDEX IDX_4C62E638A4F84F6E (destinataire_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE discussion (id INT AUTO_INCREMENT NOT NULL, nom VARCHAR(100) DEFAULT NULL, cree_le DATETIME NOT NULL, PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE discussion_utilisateur (discussion_id INT NOT NULL, utilisateur_id INT NOT NULL, INDEX IDX_99FB46E1ADED311 (discussion_id), INDEX IDX_99FB46EFB88E14F (utilisateur_id), PRIMARY KEY (discussion_id, utilisateur_id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE message (id INT AUTO_INCREMENT NOT NULL, contenu LONGTEXT NOT NULL, cree_le DATETIME NOT NULL, modifie_le DATETIME DEFAULT NULL, auteur_id INT NOT NULL, discussion_id INT DEFAULT NULL, salon_id INT DEFAULT NULL, INDEX IDX_B6BD307F60BB6FE6 (auteur_id), INDEX IDX_B6BD307F1ADED311 (discussion_id), INDEX IDX_B6BD307F4C91BDE4 (salon_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE salon (id INT AUTO_INCREMENT NOT NULL, nom VARCHAR(100) NOT NULL, serveur_id INT NOT NULL, INDEX IDX_F268F417B8F06499 (serveur_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE serveur (id INT AUTO_INCREMENT NOT NULL, nom VARCHAR(100) NOT NULL, cree_le DATETIME NOT NULL, proprietaire_id INT NOT NULL, INDEX IDX_77CC53A676C50E4A (proprietaire_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE serveur_utilisateur (serveur_id INT NOT NULL, utilisateur_id INT NOT NULL, INDEX IDX_C3773BA3B8F06499 (serveur_id), INDEX IDX_C3773BA3FB88E14F (utilisateur_id), PRIMARY KEY (serveur_id, utilisateur_id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE utilisateur (id INT AUTO_INCREMENT NOT NULL, identifiant VARCHAR(50) NOT NULL, prenom VARCHAR(100) NOT NULL, nom VARCHAR(100) NOT NULL, mot_de_passe VARCHAR(255) NOT NULL, bio LONGTEXT DEFAULT NULL, avatar VARCHAR(255) DEFAULT NULL, cree_le DATETIME NOT NULL, UNIQUE INDEX UNIQ_1D1C63B3C90409EC (identifiant), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE contact ADD CONSTRAINT FK_4C62E63895A6EE59 FOREIGN KEY (demandeur_id) REFERENCES utilisateur (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE contact ADD CONSTRAINT FK_4C62E638A4F84F6E FOREIGN KEY (destinataire_id) REFERENCES utilisateur (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE discussion_utilisateur ADD CONSTRAINT FK_99FB46E1ADED311 FOREIGN KEY (discussion_id) REFERENCES discussion (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE discussion_utilisateur ADD CONSTRAINT FK_99FB46EFB88E14F FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE message ADD CONSTRAINT FK_B6BD307F60BB6FE6 FOREIGN KEY (auteur_id) REFERENCES utilisateur (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE message ADD CONSTRAINT FK_B6BD307F1ADED311 FOREIGN KEY (discussion_id) REFERENCES discussion (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE message ADD CONSTRAINT FK_B6BD307F4C91BDE4 FOREIGN KEY (salon_id) REFERENCES salon (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE salon ADD CONSTRAINT FK_F268F417B8F06499 FOREIGN KEY (serveur_id) REFERENCES serveur (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE serveur ADD CONSTRAINT FK_77CC53A676C50E4A FOREIGN KEY (proprietaire_id) REFERENCES utilisateur (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE serveur_utilisateur ADD CONSTRAINT FK_C3773BA3B8F06499 FOREIGN KEY (serveur_id) REFERENCES serveur (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE serveur_utilisateur ADD CONSTRAINT FK_C3773BA3FB88E14F FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id) ON DELETE CASCADE');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE contact DROP FOREIGN KEY FK_4C62E63895A6EE59');
        $this->addSql('ALTER TABLE contact DROP FOREIGN KEY FK_4C62E638A4F84F6E');
        $this->addSql('ALTER TABLE discussion_utilisateur DROP FOREIGN KEY FK_99FB46E1ADED311');
        $this->addSql('ALTER TABLE discussion_utilisateur DROP FOREIGN KEY FK_99FB46EFB88E14F');
        $this->addSql('ALTER TABLE message DROP FOREIGN KEY FK_B6BD307F60BB6FE6');
        $this->addSql('ALTER TABLE message DROP FOREIGN KEY FK_B6BD307F1ADED311');
        $this->addSql('ALTER TABLE message DROP FOREIGN KEY FK_B6BD307F4C91BDE4');
        $this->addSql('ALTER TABLE salon DROP FOREIGN KEY FK_F268F417B8F06499');
        $this->addSql('ALTER TABLE serveur DROP FOREIGN KEY FK_77CC53A676C50E4A');
        $this->addSql('ALTER TABLE serveur_utilisateur DROP FOREIGN KEY FK_C3773BA3B8F06499');
        $this->addSql('ALTER TABLE serveur_utilisateur DROP FOREIGN KEY FK_C3773BA3FB88E14F');
        $this->addSql('DROP TABLE contact');
        $this->addSql('DROP TABLE discussion');
        $this->addSql('DROP TABLE discussion_utilisateur');
        $this->addSql('DROP TABLE message');
        $this->addSql('DROP TABLE salon');
        $this->addSql('DROP TABLE serveur');
        $this->addSql('DROP TABLE serveur_utilisateur');
        $this->addSql('DROP TABLE utilisateur');
    }
}
