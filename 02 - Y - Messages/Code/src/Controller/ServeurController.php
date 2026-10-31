<?php

namespace App\Controller;

use App\Entity\Salon;
use App\Entity\Serveur;
use App\Entity\Utilisateur;
use App\Form\NomType;
use App\Repository\ContactRepository;
use App\Repository\UtilisateurRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bridge\Doctrine\Attribute\MapEntity;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\CurrentUser;
use Symfony\Component\Security\Http\Attribute\IsCsrfTokenValid;

#[Route('/serveurs')]
class ServeurController extends AbstractController
{
    #[Route('/nouveau', name: 'app_serveur_nouveau')]
    public function nouveau(#[CurrentUser] Utilisateur $moi, Request $request, EntityManagerInterface $entityManager): Response
    {
        $serveur = new Serveur();
        $formulaire = $this->createForm(NomType::class, $serveur, ['data_class' => Serveur::class]);
        $formulaire->handleRequest($request);

        if ($formulaire->isSubmitted() && $formulaire->isValid()) {
            $serveur->setProprietaire($moi);
            $serveur->addMembre($moi);

            // Comme sur Discord, chaque nouveau serveur démarre avec un #général
            $salon = new Salon();
            $salon->setNom('général');
            $serveur->addSalon($salon);

            $entityManager->persist($serveur);
            $entityManager->flush();

            return $this->redirectToRoute('app_salon_voir', ['id' => $salon->getId()]);
        }

        return $this->render('_partials/formulaire_simple.html.twig', [
            'titre' => 'Créer un serveur',
            'formulaire' => $formulaire,
            'bouton' => 'Créer',
        ]);
    }

    // Ouvrir un serveur = aller dans son premier salon
    #[Route('/{id}', name: 'app_serveur_voir', requirements: ['id' => '\d+'])]
    public function voir(#[CurrentUser] Utilisateur $moi, Serveur $serveur, ContactRepository $contactRepository): Response
    {
        $this->verifierMembre($serveur, $moi);

        $premierSalon = $serveur->getSalons()->first();
        if ($premierSalon) {
            return $this->redirectToRoute('app_salon_voir', ['id' => $premierSalon->getId()]);
        }

        return $this->render('serveur/vide.html.twig', [
            'serveur' => $serveur,
            'amisAjoutables' => $contactRepository->findAmisNonMembres($moi, $serveur->getMembres()),
        ]);
    }

    #[Route('/{id}/modifier', name: 'app_serveur_modifier')]
    public function modifier(#[CurrentUser] Utilisateur $moi, Serveur $serveur, Request $request, EntityManagerInterface $entityManager): Response
    {
        $this->verifierProprietaire($serveur, $moi);

        $formulaire = $this->createForm(NomType::class, $serveur, ['data_class' => Serveur::class]);
        $formulaire->handleRequest($request);

        if ($formulaire->isSubmitted() && $formulaire->isValid()) {
            $entityManager->flush();

            return $this->redirectToRoute('app_serveur_voir', ['id' => $serveur->getId()]);
        }

        return $this->render('_partials/formulaire_simple.html.twig', [
            'titre' => 'Renommer le serveur',
            'formulaire' => $formulaire,
            'bouton' => 'Enregistrer',
        ]);
    }

    // Les salons et leurs messages sont supprimés par la base (CASCADE)
    #[Route('/{id}/supprimer', name: 'app_serveur_supprimer', methods: ['POST'])]
    #[IsCsrfTokenValid('serveur')]
    public function supprimer(#[CurrentUser] Utilisateur $moi, Serveur $serveur, EntityManagerInterface $entityManager): Response
    {
        $this->verifierProprietaire($serveur, $moi);

        $entityManager->remove($serveur);
        $entityManager->flush();

        $this->addFlash('info', 'Serveur supprimé.');

        return $this->redirectToRoute('app_accueil');
    }

    #[Route('/{id}/membres/ajouter', name: 'app_serveur_ajouter_membre', methods: ['POST'])]
    #[IsCsrfTokenValid('serveur')]
    public function ajouterMembre(
        #[CurrentUser] Utilisateur $moi,
        Serveur $serveur,
        Request $request,
        UtilisateurRepository $utilisateurRepository,
        ContactRepository $contactRepository,
        EntityManagerInterface $entityManager,
    ): Response {
        $this->verifierProprietaire($serveur, $moi);

        $ami = $utilisateurRepository->find($request->request->getInt('utilisateur'));
        if ($ami && $contactRepository->sontAmis($moi, $ami)) {
            $serveur->addMembre($ami);
            $entityManager->flush();
            $this->addFlash('success', $ami->getNomComplet().' a rejoint le serveur.');
        }

        return $this->redirectToRoute('app_serveur_voir', ['id' => $serveur->getId()]);
    }

    // Deux ids dans l'URL : MapEntity indique que {membreId} correspond à l'utilisateur
    #[Route('/{id}/membres/{membreId}/retirer', name: 'app_serveur_retirer_membre', methods: ['POST'])]
    #[IsCsrfTokenValid('serveur')]
    public function retirerMembre(
        #[CurrentUser] Utilisateur $moi,
        Serveur $serveur,
        #[MapEntity(id: 'membreId')] Utilisateur $membre,
        EntityManagerInterface $entityManager,
    ): Response {
        $this->verifierProprietaire($serveur, $moi);

        if ($membre !== $moi) {
            $serveur->removeMembre($membre);
            $entityManager->flush();
        }

        return $this->redirectToRoute('app_serveur_voir', ['id' => $serveur->getId()]);
    }

    // Le propriétaire ne peut pas quitter son serveur, il doit le supprimer
    #[Route('/{id}/quitter', name: 'app_serveur_quitter', methods: ['POST'])]
    #[IsCsrfTokenValid('serveur')]
    public function quitter(#[CurrentUser] Utilisateur $moi, Serveur $serveur, EntityManagerInterface $entityManager): Response
    {
        $this->verifierMembre($serveur, $moi);

        if (!$serveur->estProprietaire($moi)) {
            $serveur->removeMembre($moi);
            $entityManager->flush();
            $this->addFlash('info', 'Tu as quitté '.$serveur->getNom().'.');
        }

        return $this->redirectToRoute('app_accueil');
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
