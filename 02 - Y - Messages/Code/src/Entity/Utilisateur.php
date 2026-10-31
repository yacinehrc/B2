<?php

namespace App\Entity;

use App\Repository\UtilisateurRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use Symfony\Component\Security\Core\User\PasswordAuthenticatedUserInterface;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Validator\Constraints as Assert;

// Les deux interfaces permettent à Symfony de connecter cet utilisateur
#[ORM\Entity(repositoryClass: UtilisateurRepository::class)]
#[UniqueEntity(fields: ['identifiant'], message: 'Cet identifiant est déjà utilisé.')]
class Utilisateur implements UserInterface, PasswordAuthenticatedUserInterface
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    // Généré à l'inscription (Yacine Harrache -> y_har), ses règles sont dans ProfilType
    #[ORM\Column(length: 50, unique: true)]
    private ?string $identifiant = null;

    #[ORM\Column(length: 100)]
    #[Assert\NotBlank]
    private ?string $prenom = null;

    #[ORM\Column(length: 100)]
    #[Assert\NotBlank]
    private ?string $nom = null;

    // Toujours hashé, jamais en clair
    #[ORM\Column]
    private ?string $motDePasse = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    #[Assert\Length(max: 500)]
    private ?string $bio = null;

    // Nom du fichier rangé dans public/uploads/avatars
    #[ORM\Column(length: 255, nullable: true)]
    private ?string $avatar = null;

    #[ORM\Column]
    private ?\DateTimeImmutable $creeLe = null;

    #[ORM\ManyToMany(targetEntity: Discussion::class, mappedBy: 'membres')]
    private Collection $discussions;

    #[ORM\ManyToMany(targetEntity: Serveur::class, mappedBy: 'membres')]
    private Collection $serveurs;

    public function __construct()
    {
        $this->discussions = new ArrayCollection();
        $this->serveurs = new ArrayCollection();
        $this->creeLe = new \DateTimeImmutable();
    }

    // Symfony retrouve l'utilisateur connecté grâce à son identifiant
    public function getUserIdentifier(): string
    {
        return (string) $this->identifiant;
    }

    // Un seul rôle pour tout le monde, pas besoin d'admin ici
    public function getRoles(): array
    {
        return ['ROLE_USER'];
    }

    public function getPassword(): ?string
    {
        return $this->motDePasse;
    }

    public function getNomComplet(): string
    {
        return $this->prenom.' '.$this->nom;
    }

    // Lettre affichée dans la bulle quand il n'y a pas d'avatar
    public function getInitiale(): string
    {
        return mb_strtoupper(mb_substr((string) $this->prenom, 0, 1));
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getIdentifiant(): ?string
    {
        return $this->identifiant;
    }

    public function setIdentifiant(string $identifiant): static
    {
        $this->identifiant = $identifiant;

        return $this;
    }

    public function getPrenom(): ?string
    {
        return $this->prenom;
    }

    public function setPrenom(string $prenom): static
    {
        $this->prenom = $prenom;

        return $this;
    }

    public function getNom(): ?string
    {
        return $this->nom;
    }

    public function setNom(string $nom): static
    {
        $this->nom = $nom;

        return $this;
    }

    public function getMotDePasse(): ?string
    {
        return $this->motDePasse;
    }

    public function setMotDePasse(string $motDePasse): static
    {
        $this->motDePasse = $motDePasse;

        return $this;
    }

    public function getBio(): ?string
    {
        return $this->bio;
    }

    public function setBio(?string $bio): static
    {
        $this->bio = $bio;

        return $this;
    }

    public function getAvatar(): ?string
    {
        return $this->avatar;
    }

    public function setAvatar(?string $avatar): static
    {
        $this->avatar = $avatar;

        return $this;
    }

    public function getCreeLe(): ?\DateTimeImmutable
    {
        return $this->creeLe;
    }

    public function getDiscussions(): Collection
    {
        return $this->discussions;
    }

    public function getServeurs(): Collection
    {
        return $this->serveurs;
    }
}
