<?php

namespace App\Controller;

use App\Entity\Contact;
use App\Entity\Utilisateur;
use App\Repository\ContactRepository;
use App\Repository\UtilisateurRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\CurrentUser;
use Symfony\Component\Security\Http\Attribute\IsCsrfTokenValid;

class ContactController extends AbstractController
{
    // Page d'accueil : mes amis et les demandes en attente
    #[Route('/', name: 'app_accueil')]
    public function index(#[CurrentUser] Utilisateur $moi, ContactRepository $contactRepository): Response
    {
        return $this->render('contact/index.html.twig', [
            'amis' => $contactRepository->findAcceptes($moi),
            'demandesRecues' => $contactRepository->findBy(['destinataire' => $moi, 'statut' => Contact::EN_ATTENTE]),
            'demandesEnvoyees' => $contactRepository->findBy(['demandeur' => $moi, 'statut' => Contact::EN_ATTENTE]),
        ]);
    }

    #[Route('/amis/ajouter', name: 'app_contact_ajouter', methods: ['POST'])]
    #[IsCsrfTokenValid('contact')]
    public function ajouter(
        #[CurrentUser] Utilisateur $moi,
        Request $request,
        UtilisateurRepository $utilisateurRepository,
        ContactRepository $contactRepository,
        EntityManagerInterface $entityManager,
    ): Response {
        $identifiant = strtolower(trim($request->request->getString('identifiant')));
        $ami = $utilisateurRepository->findOneBy(['identifiant' => $identifiant]);

        if (null === $ami) {
            $this->addFlash('danger', "Aucun utilisateur n'a l'identifiant « $identifiant ».");
        } elseif ($ami === $moi) {
            $this->addFlash('warning', 'Tu ne peux pas t\'ajouter toi-même 😅');
        } elseif (null !== $contactRepository->findEntre($moi, $ami)) {
            $this->addFlash('warning', 'Vous êtes déjà amis ou une demande est déjà en attente.');
        } else {
            $contact = new Contact();
            $contact->setDemandeur($moi);
            $contact->setDestinataire($ami);

            $entityManager->persist($contact);
            $entityManager->flush();

            $this->addFlash('success', 'Demande d\'ami envoyée à '.$ami->getNomComplet().' !');
        }

        return $this->redirectToRoute('app_accueil');
    }

    #[Route('/amis/{id}/accepter', name: 'app_contact_accepter', methods: ['POST'])]
    #[IsCsrfTokenValid('contact')]
    public function accepter(#[CurrentUser] Utilisateur $moi, Contact $contact, EntityManagerInterface $entityManager): Response
    {
        // Seul celui qui a reçu la demande peut l'accepter
        if ($contact->getDestinataire() !== $moi) {
            throw $this->createAccessDeniedException();
        }

        $contact->setStatut(Contact::ACCEPTE);
        $entityManager->flush();

        $this->addFlash('success', 'Vous êtes maintenant amis avec '.$contact->getDemandeur()->getNomComplet().' !');

        return $this->redirectToRoute('app_accueil');
    }

    // Refuser, annuler ou retirer un ami : dans les trois cas on supprime le contact
    #[Route('/amis/{id}/supprimer', name: 'app_contact_supprimer', methods: ['POST'])]
    #[IsCsrfTokenValid('contact')]
    public function supprimer(#[CurrentUser] Utilisateur $moi, Contact $contact, EntityManagerInterface $entityManager): Response
    {
        if (!$contact->concerne($moi)) {
            throw $this->createAccessDeniedException();
        }

        $entityManager->remove($contact);
        $entityManager->flush();

        $this->addFlash('info', 'C\'est fait.');

        return $this->redirectToRoute('app_accueil');
    }
}
