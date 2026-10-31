<?php

namespace App\Repository;

use App\Entity\Contact;
use App\Entity\Utilisateur;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Common\Collections\Collection;
use Doctrine\Persistence\ManagerRegistry;

class ContactRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Contact::class);
    }

    // Mes contacts acceptés, que ce soit moi ou l'autre qui ait envoyé la demande
    public function findAcceptes(Utilisateur $moi): array
    {
        return $this->createQueryBuilder('c')
            ->where('c.statut = :statut')
            ->andWhere('c.demandeur = :moi OR c.destinataire = :moi')
            ->setParameter('statut', Contact::ACCEPTE)
            ->setParameter('moi', $moi)
            ->getQuery()
            ->getResult();
    }

    // Même chose, mais renvoie directement les utilisateurs (pratique pour les listes de choix)
    public function findAmis(Utilisateur $moi): array
    {
        return array_map(
            fn (Contact $contact) => $contact->getAutre($moi),
            $this->findAcceptes($moi)
        );
    }

    // Mes amis qui ne font pas encore partie d'un groupe ou d'un serveur
    public function findAmisNonMembres(Utilisateur $moi, Collection $membres): array
    {
        return array_values(array_filter(
            $this->findAmis($moi),
            fn (Utilisateur $ami) => !$membres->contains($ami)
        ));
    }

    public function findEntre(Utilisateur $a, Utilisateur $b): ?Contact
    {
        return $this->createQueryBuilder('c')
            ->where('(c.demandeur = :a AND c.destinataire = :b) OR (c.demandeur = :b AND c.destinataire = :a)')
            ->setParameter('a', $a)
            ->setParameter('b', $b)
            ->getQuery()
            ->getOneOrNullResult();
    }

    public function sontAmis(Utilisateur $a, Utilisateur $b): bool
    {
        $contact = $this->findEntre($a, $b);

        return null !== $contact && $contact->estAccepte();
    }
}
