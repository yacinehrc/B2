<?php

namespace App\Repository;

use App\Entity\Discussion;
use App\Entity\Utilisateur;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

class DiscussionRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Discussion::class);
    }

    // Le MP existant entre deux personnes, pour ne pas en créer un deuxième
    public function findMpEntre(Utilisateur $a, Utilisateur $b): ?Discussion
    {
        // On joint deux fois les membres : une fois pour $a, une fois pour $b
        return $this->createQueryBuilder('d')
            ->join('d.membres', 'm1')
            ->join('d.membres', 'm2')
            ->where('d.nom IS NULL')
            ->andWhere('m1 = :a')
            ->andWhere('m2 = :b')
            ->andWhere('SIZE(d.membres) = 2')
            ->setParameter('a', $a)
            ->setParameter('b', $b)
            ->setMaxResults(1)
            ->getQuery()
            ->getOneOrNullResult();
    }
}
