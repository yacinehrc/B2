<?php

namespace App\Service;

use App\Repository\UtilisateurRepository;
use Symfony\Component\String\Slugger\SluggerInterface;

// Identifiant par défaut : 1re lettre du prénom + "_" + 3 lettres du nom (Yacine Harrache -> y_har)
class GenerateurIdentifiant
{
    public function __construct(
        private UtilisateurRepository $utilisateurRepository,
        private SluggerInterface $slugger,
    ) {
    }

    public function generer(string $prenom, string $nom): string
    {
        // Le slugger enlève accents, espaces et caractères spéciaux ("Élodie" -> "Elodie")
        $prenomPropre = strtolower($this->slugger->slug($prenom, ''));
        $nomPropre = strtolower($this->slugger->slug($nom, ''));

        $base = substr($prenomPropre, 0, 1).'_'.substr($nomPropre, 0, 3);

        // Déjà pris ? On ajoute un numéro : y_har2, y_har3...
        $identifiant = $base;
        $numero = 2;
        while ($this->utilisateurRepository->identifiantExiste($identifiant)) {
            $identifiant = $base.$numero;
            ++$numero;
        }

        return $identifiant;
    }
}
