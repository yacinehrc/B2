<?php

namespace App\Entity;

use App\Repository\DiscussionRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

// Sans nom c'est un MP à deux, avec un nom c'est un groupe
#[ORM\Entity(repositoryClass: DiscussionRepository::class)]
class Discussion
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $nom = null;

    // Doctrine stocke cette relation dans la table de liaison discussion_utilisateur
    #[ORM\ManyToMany(targetEntity: Utilisateur::class, inversedBy: 'discussions')]
    private Collection $membres;

    #[ORM\OneToMany(targetEntity: Message::class, mappedBy: 'discussion')]
    #[ORM\OrderBy(['creeLe' => \SortDirection::Ascending])] // du plus ancien au plus récent
    private Collection $messages;

    #[ORM\Column]
    private ?\DateTimeImmutable $creeLe = null;

    public function __construct()
    {
        $this->membres = new ArrayCollection();
        $this->messages = new ArrayCollection();
        $this->creeLe = new \DateTimeImmutable();
    }

    public function estUnGroupe(): bool
    {
        return null !== $this->nom;
    }

    public function estMembre(Utilisateur $utilisateur): bool
    {
        return $this->membres->contains($utilisateur);
    }

    // Nom du groupe, ou nom de l'autre personne pour un MP
    public function getTitrePour(Utilisateur $moi): string
    {
        if ($this->estUnGroupe()) {
            return $this->nom;
        }

        $autre = $this->getAutreMembre($moi);

        return $autre ? $autre->getNomComplet() : 'Discussion';
    }

    public function getAutreMembre(Utilisateur $moi): ?Utilisateur
    {
        foreach ($this->membres as $membre) {
            if ($membre !== $moi) {
                return $membre;
            }
        }

        return null;
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getNom(): ?string
    {
        return $this->nom;
    }

    public function setNom(?string $nom): static
    {
        $this->nom = $nom;

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

    public function getMessages(): Collection
    {
        return $this->messages;
    }

    public function getCreeLe(): ?\DateTimeImmutable
    {
        return $this->creeLe;
    }
}
