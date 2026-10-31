<?php

namespace App\Repository;

use App\Entity\Utilisateur;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

// find(), findAll(), findBy() et findOneBy() sont déjà fournis par ServiceEntityRepository
class UtilisateurRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Utilisateur::class);
    }

    public function identifiantExiste(string $identifiant): bool
    {
        return null !== $this->findOneBy(['identifiant' => $identifiant]);
    }
}
