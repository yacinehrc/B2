<?php

namespace App\Entity;

use App\Repository\ContactRepository;
use Doctrine\ORM\Mapping as ORM;

// Une demande d'ami : refuser ou retirer un ami revient à supprimer la ligne
#[ORM\Entity(repositoryClass: ContactRepository::class)]
class Contact
{
    public const EN_ATTENTE = 'en_attente';
    public const ACCEPTE = 'accepte';

    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    // CASCADE : le contact disparaît si l'un des deux comptes est supprimé
    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private ?Utilisateur $demandeur = null;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private ?Utilisateur $destinataire = null;

    #[ORM\Column(length: 20)]
    private string $statut = self::EN_ATTENTE;

    #[ORM\Column]
    private ?\DateTimeImmutable $creeLe = null;

    public function __construct()
    {
        $this->creeLe = new \DateTimeImmutable();
    }

    // L'autre personne du contact, peu importe qui a envoyé la demande
    public function getAutre(Utilisateur $moi): ?Utilisateur
    {
        return $this->demandeur === $moi ? $this->destinataire : $this->demandeur;
    }

    public function concerne(Utilisateur $utilisateur): bool
    {
        return $this->demandeur === $utilisateur || $this->destinataire === $utilisateur;
    }

    public function estAccepte(): bool
    {
        return self::ACCEPTE === $this->statut;
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getDemandeur(): ?Utilisateur
    {
        return $this->demandeur;
    }

    public function setDemandeur(Utilisateur $demandeur): static
    {
        $this->demandeur = $demandeur;

        return $this;
    }

    public function getDestinataire(): ?Utilisateur
    {
        return $this->destinataire;
    }

    public function setDestinataire(Utilisateur $destinataire): static
    {
        $this->destinataire = $destinataire;

        return $this;
    }

    public function getStatut(): string
    {
        return $this->statut;
    }

    public function setStatut(string $statut): static
    {
        $this->statut = $statut;

        return $this;
    }

    public function getCreeLe(): ?\DateTimeImmutable
    {
        return $this->creeLe;
    }
}
