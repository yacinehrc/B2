<?php

namespace App\Controller;

use App\Entity\Utilisateur;
use App\Form\InscriptionType;
use App\Service\GenerateurIdentifiant;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Attribute\Route;

class InscriptionController extends AbstractController
{
    #[Route('/inscription', name: 'app_inscription')]
    public function inscription(
        Request $request,
        UserPasswordHasherInterface $hasher,
        GenerateurIdentifiant $generateurIdentifiant,
        EntityManagerInterface $entityManager,
        Security $security,
    ): Response {
        if ($this->getUser()) {
            return $this->redirectToRoute('app_accueil');
        }

        $utilisateur = new Utilisateur();
        $formulaire = $this->createForm(InscriptionType::class, $utilisateur);
        $formulaire->handleRequest($request);

        if ($formulaire->isSubmitted() && $formulaire->isValid()) {
            $utilisateur->setIdentifiant(
                $generateurIdentifiant->generer($utilisateur->getPrenom(), $utilisateur->getNom())
            );

            $motDePasseClair = $formulaire->get('motDePasseClair')->getData();
            $utilisateur->setMotDePasse($hasher->hashPassword($utilisateur, $motDePasseClair));

            $entityManager->persist($utilisateur);
            $entityManager->flush();

            // Connexion automatique juste après l'inscription
            $security->login($utilisateur, 'form_login', 'main');

            $this->addFlash('success', sprintf(
                'Bienvenue %s ! Ton identifiant de connexion est « %s » (tu peux le changer dans ton profil).',
                $utilisateur->getPrenom(),
                $utilisateur->getIdentifiant()
            ));

            return $this->redirectToRoute('app_accueil');
        }

        return $this->render('security/inscription.html.twig', [
            'formulaire' => $formulaire,
        ]);
    }
}
