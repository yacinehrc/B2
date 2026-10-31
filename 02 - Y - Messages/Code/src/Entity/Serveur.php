<?php

namespace App\Entity;

use App\Repository\ServeurRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: ServeurRepository::class)]
class Serveur
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 100)]
    private ?string $nom = null;

    // Seul le propriétaire peut modifier ou supprimer le serveur
    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private ?Utilisateur $proprietaire = null;

    #[ORM\ManyToMany(targetEntity: Utilisateur::class, inversedBy: 'serveurs')]
    private Collection $membres;

    // persist en cascade : les nouveaux salons sont enregistrés en même temps que le serveur
    #[ORM\OneToMany(targetEntity: Salon::class, mappedBy: 'serveur', cascade: ['persist'])]
    #[ORM\OrderBy(['id' => \SortDirection::Ascending])] // dans l'ordre de création
    private Collection $salons;

    #[ORM\Column]
    private ?\DateTimeImmutable $creeLe = null;

    public function __construct()
    {
        $this->membres = new ArrayCollection();
        $this->salons = new ArrayCollection();
        $this->creeLe = new \DateTimeImmutable();
    }

    public function estMembre(Utilisateur $utilisateur): bool
    {
        return $this->membres->contains($utilisateur);
    }

    public function estProprietaire(Utilisateur $utilisateur): bool
    {
        return $this->proprietaire === $utilisateur;
    }

    // Affiché dans la bulle de la barre des serveurs ("Gaming" -> "GA")
    public function getInitiales(): string
    {
        return mb_strtoupper(mb_substr((string) $this->nom, 0, 2));
    }

    public function getId(): ?int
    {
        return $this->id;
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

    public function getProprietaire(): ?Utilisateur
    {
        return $this->proprietaire;
    }

    public function setProprietaire(Utilisateur $proprietaire): static
    {
        $this->proprietaire = $proprietaire;

        return $this;
    }

    public function getMembres(): Collection
    {
        return $this->membres;
    }

    public function addMembre(Utilisateur $membre): static
    {
        if (!$this->membres->contains($membre)) {
            $this->membres->add($membre);
        }

        return $this;
    }

    public function removeMembre(Utilisateur $membre): static
    {
        $this->membres->removeElement($membre);

        return $this;
    }

    public function getSalons(): Collection
    {
        return $this->salons;
    }

    public function addSalon(Salon $salon): static
    {
        if (!$this->salons->contains($salon)) {
            $this->salons->add($salon);
            $salon->setServeur($this);
        }

        return $this;
    }

    public function getCreeLe(): ?\DateTimeImmutable
    {
        return $this->creeLe;
    }
}
