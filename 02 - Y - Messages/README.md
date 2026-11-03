# Y - Messages

![Salon d'un serveur](./Images/salon.png)

> Application de messagerie inspirée de Discord : amis, messages privés, groupes, serveurs et salons, avec des messages qui s'affichent en direct. Développée en **Symfony 8**, **Doctrine** et **MySQL** (via Docker), avec une interface **Bootstrap** et **Tailwind CSS**.

---

## Sommaire

- [Introduction](#introduction)
- [Fonctionnalités](#fonctionnalités)
- [Technologies utilisées](#technologies-utilisées)
- [Démonstration](#démonstration)
- [Architecture](#architecture)
- [Base de données](#base-de-données)
- [Sécurité](#sécurité)
- [Installation](#installation)
- [Identifiants de test](#identifiants-de-test)
- [Arborescence du dépôt](#arborescence-du-dépôt)
- [Difficultés rencontrées](#difficultés-rencontrées)
- [Perspectives d'évolution](#perspectives-dévolution)
- [Conclusion](#conclusion)

---

## Introduction

Ce projet est une **messagerie instantanée** réalisée dans le cadre de ma 2ème année, avec pour objectif de reproduire les fonctionnalités principales de Discord à l'aide du framework **Symfony**. L'application repose sur une architecture **MVC** : les entités Doctrine décrivent les données, les contrôleurs gèrent chaque action et les templates Twig construisent l'interface.

Le projet couvre un **CRUD complet** sur six entités (utilisateurs, contacts, discussions, serveurs, salons et messages), une authentification sécurisée et un système de droits : on ne peut lire que les conversations et serveurs dont on est membre. La base de données MySQL tourne dans un conteneur **Docker** et se crée automatiquement au premier lancement à partir de scripts SQL.

---

## Fonctionnalités

- **Inscription et connexion** : création de compte avec prénom, nom et mot de passe, connexion obligatoire pour accéder à l'application
- **Identifiant automatique** : généré à l'inscription à partir de la 1ʳᵉ lettre du prénom et des 3 premières lettres du nom (Alice Martin → `a_mar`), avec un numéro ajouté s'il est déjà pris
- **Profil** : modification du nom, de l'identifiant, de la bio, de l'avatar et du mot de passe, suppression du compte
- **Contacts** : envoi d'une demande d'ami par identifiant, acceptation, refus, annulation et retrait d'un ami
- **Messages privés** : discussion à deux avec un ami, créée automatiquement à la première ouverture
- **Groupes** : discussion à plusieurs, renommage, ajout de membres et départ du groupe
- **Serveurs et salons** : création d'un serveur avec un salon `#général`, ajout de salons, invitation et retrait de membres, gestion réservée au propriétaire
- **Messages** : envoi, modification (avec la mention « modifié ») et suppression de ses propres messages
- **Affichage en direct** : les nouveaux messages apparaissent sans recharger la page grâce à un rafraîchissement automatique toutes les 3 secondes
- **Interface responsive** : quatre colonnes sur ordinateur, menus repliés dans des tiroirs sur tablette et téléphone

---

## Technologies utilisées

| Outil | Rôle |
|---|---|
| **PHP 8.4** + **Symfony 8.1** | Framework back-end : routes, contrôleurs, formulaires, sécurité |
| **Doctrine ORM** | Lien entre les classes PHP (entités) et les tables MySQL |
| **Twig** | Moteur de templates pour générer les pages HTML |
| **MySQL 8.4** + **phpMyAdmin** | Base de données et interface d'administration, lancées avec **Docker Compose** |
| **Bootstrap 5.3** | Composants d'interface : boutons, formulaires, alertes, menus déroulants, tiroirs (offcanvas) sur petit écran |
| **Tailwind CSS 3** | Mise en page responsive et couleurs, avec le préfixe `tw-` pour cohabiter avec Bootstrap |
| **JavaScript** | Rafraîchissement automatique des messages avec `fetch()` |

---

## Démonstration

### Connexion et inscription

L'accès à l'application nécessite un compte. La page de connexion demande l'identifiant et le mot de passe ; la vérification est assurée par le composant de sécurité de Symfony.

![Page de connexion](./Images/connexion.png)

À l'inscription, l'utilisateur saisit seulement son prénom, son nom et son mot de passe. L'identifiant qui lui sera attribué s'affiche en direct pendant la saisie.

![Page d'inscription](./Images/inscription.png)

### Amis

La page d'accueil regroupe l'ajout d'un ami par son identifiant, les demandes reçues (à accepter ou refuser) et la liste des amis, avec un accès direct au message privé.

![Page des amis](./Images/amis.png)

### Messages privés et groupes

Les discussions sont listées dans la barre latérale. Un message privé relie deux amis ; on peut modifier ou supprimer ses propres messages, qui sont alors marqués « modifié ».

![Message privé](./Images/message-prive.png)

Un groupe réunit plusieurs amis autour d'un nom. La colonne de droite affiche les membres et permet d'en ajouter de nouveaux.

![Discussion de groupe](./Images/groupe.png)

Une nouvelle discussion se crée en cochant un ou plusieurs amis : un seul ami ouvre un message privé, plusieurs amis créent un groupe.

![Création d'une discussion](./Images/nouvelle-discussion.png)

### Serveurs et salons

Chaque serveur apparaît sous forme de bulle dans la colonne de gauche. Il contient des salons textuels et une liste de membres, où le propriétaire est signalé par une étoile.

![Salon d'un serveur](./Images/salon.png)

Le menu du serveur permet au propriétaire de créer un salon, de renommer le serveur ou de le supprimer avec tout son contenu. Les autres membres peuvent seulement le quitter.

![Menu du serveur](./Images/menu-serveur.png)

### Profil

Le profil affiche l'avatar, l'identifiant, la bio et la date d'inscription. Depuis un autre profil, un bouton permet d'envoyer directement un message.

![Profil utilisateur](./Images/profil.png)

### Version mobile

L'interface s'adapte à la largeur de l'écran. Sur téléphone, seule la conversation reste affichée : le bouton ☰ ouvre la liste des serveurs et des discussions, et le bouton des membres ouvre la colonne de droite. Ces tiroirs reposent sur le composant *offcanvas* de Bootstrap. Les actions qui n'apparaissent qu'au survol sur ordinateur restent visibles au doigt.

<p align="center">
  <img src="./Images/mobile-discussion.png" alt="Discussion sur téléphone" width="250">
  &nbsp;
  <img src="./Images/mobile-menu.png" alt="Menu ouvert sur téléphone" width="250">
  &nbsp;
  <img src="./Images/mobile-membres.png" alt="Membres d'un serveur sur téléphone" width="250">
</p>

---

## Architecture

L'application suit le modèle **MVC** de Symfony : une URL appelle une méthode de contrôleur, qui récupère les données via Doctrine puis les transmet à un template Twig.

```
Navigateur ──► Route (#[Route]) ──► Contrôleur ──► Repository / Entité ──► MySQL
     ▲                                   │
     └──────────── HTML ◄── Template Twig ◄┘
```

| Couche | Dossier | Contenu |
|---|---|---|
| Entités | `src/Entity/` | `Utilisateur`, `Contact`, `Discussion`, `Serveur`, `Salon`, `Message` |
| Repositories | `src/Repository/` | Requêtes personnalisées (amis d'un utilisateur, MP existant entre deux personnes...) |
| Contrôleurs | `src/Controller/` | Un contrôleur par domaine : inscription, contacts, discussions, serveurs, salons, messages, profil |
| Formulaires | `src/Form/` | Formulaires Symfony avec validation |
| Service | `src/Service/` | `GenerateurIdentifiant`, qui construit l'identifiant unique à l'inscription |
| Vues | `templates/` | Templates Twig, découpés en éléments réutilisables (avatar, zone de chat, barres latérales) |

**L'affichage en direct** repose sur du *polling* : un script JavaScript interroge toutes les 3 secondes une route qui renvoie uniquement la liste des messages, puis la remplace dans la page sans la recharger.

---

## Base de données

### MCD

```mermaid
flowchart LR
    U["UTILISATEUR<br>id<br>identifiant<br>prenom<br>nom<br>mot_de_passe<br>bio<br>avatar<br>cree_le"]
    C["CONTACT<br>id<br>statut<br>cree_le"]
    D["DISCUSSION<br>id<br>nom<br>cree_le"]
    S["SERVEUR<br>id<br>nom<br>cree_le"]
    SA["SALON<br>id<br>nom"]
    M["MESSAGE<br>id<br>contenu<br>cree_le<br>modifie_le"]

    U ---|"0,n"| env((envoyer))
    env ---|"1,1"| C
    U ---|"0,n"| rec((recevoir))
    rec ---|"1,1"| C
    U ---|"0,n"| par((participer))
    par ---|"1,n"| D
    U ---|"0,n"| pos((posséder))
    pos ---|"1,1"| S
    U ---|"0,n"| mem((être membre))
    mem ---|"1,n"| S
    S ---|"0,n"| con((contenir))
    con ---|"1,1"| SA
    U ---|"0,n"| ecr((écrire))
    ecr ---|"1,1"| M
    D ---|"0,n"| cd((contenir))
    cd ---|"0,1"| M
    SA ---|"0,n"| cs((contenir))
    cs ---|"0,1"| M
```

Les cardinalités se lisent « minimum, maximum ». Trois règles de gestion complètent le schéma :

- un message appartient **soit** à une discussion, **soit** à un salon, jamais aux deux ;
- une discussion qui n'a plus de membre est supprimée ;
- un serveur peut ne contenir aucun salon si son propriétaire les a tous supprimés.

### Tables

Les associations *participer* et *être membre* deviennent les tables de liaison `discussion_utilisateur` et `serveur_utilisateur`. Les autres associations deviennent des clés étrangères avec `ON DELETE CASCADE` : supprimer un serveur supprime ses salons et leurs messages.

| Table | Contenu |
|---|---|
| `utilisateur` | Comptes : identifiant unique, prénom, nom, mot de passe hashé, bio, avatar |
| `contact` | Demandes d'ami : demandeur, destinataire et statut (`en_attente` ou `accepte`) |
| `discussion` | Messages privés (sans nom) et groupes (avec nom) |
| `serveur` | Serveurs et leur propriétaire |
| `salon` | Salons rattachés à un serveur |
| `message` | Messages rattachés à une discussion ou à un salon |

Les scripts de création et les données de démonstration se trouvent dans [`Code/database/`](./Code/database/). Une migration Doctrine ([`Code/src/Migrations/`](./Code/src/Migrations/)) crée les mêmes tables pour une installation sans Docker.

---

## Sécurité

- **Mots de passe hashés** avec bcrypt, jamais stockés en clair
- **Accès protégé** : toutes les pages exigent d'être connecté, sauf la connexion et l'inscription
- **Contrôle des droits** : chaque action vérifie que l'utilisateur est membre de la discussion ou du serveur (erreur 403 sinon), et seul le propriétaire peut gérer un serveur
- **Protection CSRF** : chaque formulaire et chaque action de suppression contiennent un jeton vérifié par Symfony
- **Protection XSS** : Twig échappe automatiquement le contenu des messages
- **Validation** des données côté serveur (champs obligatoires, longueur, format de l'identifiant, type et taille des images)

---

## Installation

Le projet s'installe **avec Docker** (le plus simple) ou **sans Docker**, sur un MySQL ou un MariaDB déjà installé (XAMPP, WAMP, Laragon...). Seule l'étape 3 change.

### Prérequis

| Outil | Rôle | Vérification |
|---|---|---|
| [PHP 8.4 ou plus](https://www.php.net/downloads.php) | Langage du projet, avec les extensions `pdo_mysql` et `fileinfo` activées | `php -v` puis `php -m` |
| [Composer](https://getcomposer.org/download/) | Installe les bibliothèques PHP | `composer -V` |
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) **ou** MySQL 8 / MariaDB 10.4+ | Base de données | `docker --version` |
| [Symfony CLI](https://symfony.com/download) *(facultatif)* | Serveur web local, remplaçable par celui de PHP | `symfony version` |

Une connexion Internet reste nécessaire pendant l'utilisation : Bootstrap et Tailwind sont chargés depuis un CDN.

### 1. Récupérer le projet

Le dépôt contient plusieurs projets : l'application se trouve dans `02 - Y - Messages/Code`. Sous Windows, il vaut mieux le placer dans un dossier au chemin court (`C:\dev`, par exemple), car certains noms de fichiers du dépôt sont longs.

```bash
git clone -c core.longpaths=true https://github.com/yacinehrc/B2.git
```

```bash
cd "B2/02 - Y - Messages/Code"
```

Toutes les commandes suivantes se lancent dans ce dossier.

### 2. Installer les dépendances

```bash
composer install
```

### 3. Préparer la base de données

#### Option A : avec Docker

Ouvrir Docker Desktop, attendre l'indication *Engine running*, puis lancer :

```bash
docker compose up -d --wait database
```

La commande rend la main quand la base est prête (une à deux minutes la première fois, le temps de télécharger MySQL). Les tables et les comptes de test sont créés automatiquement par les scripts de [`Code/database/`](./Code/database/). La base écoute sur le port **3307**, pour ne pas gêner un MySQL déjà installé. Aucune configuration n'est à modifier.

#### Option B : sans Docker

Créer dans le dossier `Code` un fichier nommé `.env.local`, contenant **une seule** de ces lignes, à adapter (mot de passe, port et version du serveur) :

```bash
# XAMPP, WAMP ou Laragon avec MariaDB (root sans mot de passe)
DATABASE_URL="mysql://root:@127.0.0.1:3306/y_messages?serverVersion=10.4.32-MariaDB&charset=utf8mb4"
```

```bash
# MySQL
DATABASE_URL="mysql://root:MOT_DE_PASSE@127.0.0.1:3306/y_messages?serverVersion=8.4&charset=utf8mb4"
```

Créer ensuite la base et ses tables avec Doctrine :

```bash
php bin/console doctrine:database:create
```

```bash
php bin/console doctrine:migrations:migrate --no-interaction
```

Pour disposer des comptes de test, importer le fichier [`database/02_donnees_demo.sql`](./Code/database/02_donnees_demo.sql) dans la base `y_messages` avec phpMyAdmin (onglet *Importer*). Sans cet import, l'application fonctionne aussi : il suffit de créer un compte sur la page d'inscription.

### 4. Vérifier la base

Les deux lignes affichées doivent indiquer `[OK]` :

```bash
php bin/console doctrine:schema:validate
```

### 5. Démarrer le site

Avec Symfony CLI :

```bash
symfony serve -d
```

Ou, sans Symfony CLI, avec le serveur intégré à PHP (à laisser ouvert dans son terminal) :

```bash
php -S 127.0.0.1:8000 -t public
```

### 6. Ouvrir l'application

Aller sur <http://127.0.0.1:8000> (ou l'adresse affichée par Symfony si le port 8000 est déjà pris) et se connecter avec un [compte de test](#identifiants-de-test), par exemple `a_mar` / `motdepasse`.

Pour consulter la base avec Docker, phpMyAdmin se lance séparément avec `docker compose up -d phpmyadmin`, puis s'ouvre sur <http://localhost:8081> (utilisateur `ymessages`, mot de passe `ymessages`).

### En cas de problème

| Message | Cause et solution |
|---|---|
| `composer install` signale `php` ou `ext-...` manquant | PHP est trop ancien ou une extension est désactivée. Dans le fichier `php.ini` (indiqué par `php --ini`), retirer le `;` devant `extension=pdo_mysql` et `extension=fileinfo`. |
| `Connection refused` ou `SQLSTATE[HY000] [2002]` | La base n'est pas démarrée. Lancer Docker Desktop puis l'étape 3, ou démarrer MySQL dans XAMPP / WAMP. |
| `SQLSTATE[HY000] [1045] Access denied` | Identifiant ou mot de passe incorrect dans `.env.local`. |
| `SQLSTATE[HY000] [1049] Unknown database` | La base n'existe pas encore : lancer `doctrine:database:create` (option B). |
| `port is already allocated` | Le port 3307 est déjà pris. Changer `"3307:3306"` dans `compose.yaml`, puis créer un `.env.local` qui reprend `DATABASE_URL` du fichier `.env` avec le nouveau port. |
| `Table ... doesn't exist` ou comptes de test absents | Remettre la base à zéro : `docker compose down -v`, puis l'étape 3 (option A). |
| `Filename too long` pendant le `git clone` | Recommencer depuis un dossier au chemin plus court. |

### Commandes utiles

| Action | Commande |
|---|---|
| Arrêter le serveur web | `symfony server:stop` (ou `Ctrl + C` avec le serveur PHP) |
| Arrêter la base (les données sont conservées) | `docker compose stop` |
| Relancer le projet plus tard | `docker compose up -d --wait database` puis `symfony serve -d` |
| Remettre la base à zéro avec les données de démonstration | `docker compose down -v` puis `docker compose up -d --wait database` |

Le guide technique [`Code/README.md`](./Code/README.md) détaille la structure du code et les routes.

---

## Identifiants de test

Tous les comptes de démonstration utilisent le mot de passe **`motdepasse`**.

| Identifiant | Utilisateur | Situation |
|---|---|---|
| `a_mar` | Alice Martin | Propriétaire du serveur *Gaming*, a reçu une demande d'ami de David |
| `b_dup` | Bob Dupont | Ami d'Alice et de Chloé |
| `c_ber` | Chloé Bernard | Amie d'Alice et de Bob |
| `d_ler` | David Leroy | En attente de la réponse d'Alice |

Pour tester l'affichage en direct, il suffit d'ouvrir deux navigateurs connectés avec deux comptes différents.

---

## Arborescence du dépôt

```
02 - Y - Messages/
├── README.md
├── Images/           → Captures d'écran du README
└── Code/             → Projet Symfony
    ├── compose.yaml  → MySQL + phpMyAdmin (Docker)
    ├── database/     → Scripts SQL : tables et données de démo
    ├── config/       → Configuration (sécurité, Doctrine, Twig...)
    ├── public/       → CSS, JavaScript de l'auto-refresh, avatars
    ├── src/
    │   ├── Controller/
    │   ├── Entity/
    │   ├── Form/
    │   ├── Repository/
    │   └── Service/
    └── templates/    → Vues Twig
```

---

## Difficultés rencontrées

- **Faire cohabiter Bootstrap et Tailwind** : les deux frameworks utilisent des noms de classes proches. Tailwind a été configuré avec le préfixe `tw-` et sans sa réinitialisation CSS, ce qui permet d'utiliser Bootstrap pour les composants et Tailwind pour la mise en page.
- **Effet de bord de l'auto-refresh** : après une déconnexion, les requêtes automatiques étaient mémorisées par Symfony comme « page à ouvrir après connexion », et l'utilisateur arrivait sur une page incomplète. Le problème a été corrigé en marquant ces requêtes comme AJAX (`X-Requested-With`).
- **Modification de l'identifiant** : une saisie invalide restait en mémoire et Symfony déconnectait l'utilisateur, croyant que son identifiant avait changé. L'entité est maintenant rechargée depuis la base en cas d'erreur.
- **Adapter quatre colonnes à un téléphone** : sur un écran de 375 px, les deux barres de gauche prenaient presque toute la largeur. Elles sont devenues des tiroirs Bootstrap (`offcanvas-md` et `offcanvas-lg`), affichés normalement sur grand écran et repliés derrière un bouton en dessous. Les boutons visibles seulement au survol ont aussi été rendus accessibles sur écran tactile.
- **Environnement Docker** : sous Windows, Docker Desktop refusait de démarrer à cause d'anciens fichiers socket impossibles à supprimer. La solution est documentée dans le guide d'installation.

---

## Perspectives d'évolution

- **Vrai temps réel** : remplacer le rafraîchissement toutes les 3 secondes par Mercure ou des WebSockets
- **Messages non lus** : compteur de nouveaux messages par discussion
- **Rôles dans les serveurs** : modérateurs pouvant gérer les salons et supprimer des messages
- **Invitations** : lien d'invitation pour rejoindre un serveur sans être ami avec son propriétaire
- **Messages enrichis** : images, fichiers joints, réactions et réponses à un message
- **Pagination** : chargement progressif des anciens messages
- **Qualité** : tests automatisés avec PHPUnit et centralisation des droits dans des Voters Symfony
- **Application installable** : transformer le site en application mobile avec des notifications de nouveaux messages

---

## Conclusion

Ce projet m'a permis de découvrir le framework Symfony en construisant une application complète, de la base de données à l'interface. Il m'a fait travailler :

- la modélisation des données et leur traduction en entités Doctrine ;
- l'organisation d'une application en MVC ;
- la sécurité web : authentification, hachage des mots de passe, contrôle des droits et protections CSRF et XSS ;
- la mise en place d'un environnement de développement avec Docker ;
- la gestion d'un affichage dynamique en JavaScript.

---

*Réalisé par [Yacine Harrache](https://github.com/yacinehrc) — Étudiant en 2ème année | EPSI Lille*
