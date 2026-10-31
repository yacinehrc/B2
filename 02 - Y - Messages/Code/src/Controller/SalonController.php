<?php

namespace App\Controller;

use App\Entity\Message;
use App\Entity\Salon;
use App\Entity\Serveur;
use App\Entity\Utilisateur;
use App\Form\MessageType;
use App\Form\NomType;
use App\Repository\ContactRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\CurrentUser;
use Symfony\Component\Security\Http\Attribute\IsCsrfTokenValid;

class SalonController extends AbstractController
{
    // Même fonctionnement que DiscussionController::voir()
    #[Route('/salons/{id}', name: 'app_salon_voir', requirements: ['id' => '\d+'])]
    public function voir(
        #[CurrentUser] Utilisateur $moi,
        Salon $salon,
        Request $request,
        ContactRepository $contactRepository,
        EntityManagerInterface $entityManager,
    ): Response {
        $serveur = $salon->getServeur();
        $this->verifierMembre($serveur, $moi);

        $message = new Message();
        $formulaire = $this->createForm(MessageType::class, $message);
        $formulaire->handleRequest($request);

        if ($formulaire->isSubmitted() && $formulaire->isValid()) {
            $message->setAuteur($moi);
            $message->setSalon($salon);
            $entityManager->persist($message);
            $entityManager->flush();

            return $this->redirectToRoute('app_salon_voir', ['id' => $salon->getId()]);
        }

        return $this->render('salon/voir.html.twig', [
            'salon' => $salon,
            'serveur' => $serveur,
            'formulaire' => $formulaire,
            'amisAjoutables' => $contactRepository->findAmisNonMembres($moi, $serveur->getMembres()),
        ]);
    }

    // Juste la liste des messages pour l'auto-refresh
    #[Route('/salons/{id}/messages', name: 'app_salon_messages')]
    public function messages(#[CurrentUser] Utilisateur $moi, Salon $salon): Response
    {
        $this->verifierMembre($salon->getServeur(), $moi);

        return $this->render('message/_liste.html.twig', [
            'messages' => $salon->getMessages(),
        ]);
    }

    #[Route('/serveurs/{id}/salons/nouveau', name: 'app_salon_nouveau')]
    public function nouveau(#[CurrentUser] Utilisateur $moi, Serveur $serveur, Request $request, EntityManagerInterface $entityManager): Response
    {
        $this->verifierProprietaire($serveur, $moi);

        $salon = new Salon();
        $formulaire = $this->createForm(NomType::class, $salon, ['data_class' => Salon::class]);
        $formulaire->handleRequest($request);

        if ($formulaire->isSubmitted() && $formulaire->isValid()) {
            $serveur->addSalon($salon);
            $entityManager->persist($salon);
            $entityManager->flush();

            return $this->redirectToRoute('app_salon_voir', ['id' => $salon->getId()]);
        }

        return $this->render('_partials/formulaire_simple.html.twig', [
            'titre' => 'Nouveau salon dans '.$serveur->getNom(),
            'formulaire' => $formulaire,
            'bouton' => 'Créer',
        ]);
    }

    #[Route('/salons/{id}/modifier', name: 'app_salon_modifier')]
    public function modifier(#[CurrentUser] Utilisateur $moi, Salon $salon, Request $request, EntityManagerInterface $entityManager): Response
    {
        $this->verifierProprietaire($salon->getServeur(), $moi);

        $formulaire = $this->createForm(NomType::class, $salon, ['data_class' => Salon::class]);
        $formulaire->handleRequest($request);

        if ($formulaire->isSubmitted() && $formulaire->isValid()) {
            $entityManager->flush();

            return $this->redirectToRoute('app_salon_voir', ['id' => $salon->getId()]);
        }

        return $this->render('_partials/formulaire_simple.html.twig', [
            'titre' => 'Renommer #'.$salon->getNom(),
            'formulaire' => $formulaire,
            'bouton' => 'Enregistrer',
        ]);
    }

    #[Route('/salons/{id}/supprimer', name: 'app_salon_supprimer', methods: ['POST'])]
    #[IsCsrfTokenValid('salon')]
    public function supprimer(#[CurrentUser] Utilisateur $moi, Salon $salon, EntityManagerInterface $entityManager): Response
    {
        $serveur = $salon->getServeur();
        $this->verifierProprietaire($serveur, $moi);

        $serveur->getSalons()->removeElement($salon);
        $entityManager->remove($salon);
        $entityManager->flush();

        return $this->redirectToRoute('app_serveur_voir', ['id' => $serveur->getId()]);
    }

    private function verifierMembre(Serveur $serveur, Utilisateur $moi): void
    {
        if (!$serveur->estMembre($moi)) {
            throw $this->createAccessDeniedException('Tu n\'es pas membre de ce serveur.');
        }
    }

    private function verifierProprietaire(Serveur $serveur, Utilisateur $moi): void
    {
        if (!$serveur->estProprietaire($moi)) {
            throw $this->createAccessDeniedException('Seul le propriétaire peut faire ça.');
        }
    }
}
