<?php

namespace App\Entity;

use App\Repository\SalonRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: SalonRepository::class)]
class Salon
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 100)]
    private ?string $nom = null;

    #[ORM\ManyToOne(inversedBy: 'salons')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private ?Serveur $serveur = null;

    #[ORM\OneToMany(targetEntity: Message::class, mappedBy: 'salon')]
    #[ORM\OrderBy(['creeLe' => \SortDirection::Ascending])] // du plus ancien au plus récent
    private Collection $messages;

    public function __construct()
    {
        $this->messages = new ArrayCollection();
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

    public function getServeur(): ?Serveur
    {
        return $this->serveur;
    }

    public function setServeur(Serveur $serveur): static
    {
        $this->serveur = $serveur;

        return $this;
    }

    public function getMessages(): Collection
    {
        return $this->messages;
    }
}
