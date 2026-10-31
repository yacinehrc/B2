<?php

namespace App\Controller;

use App\Entity\Discussion;
use App\Entity\Message;
use App\Entity\Utilisateur;
use App\Form\MessageType;
use App\Form\NomType;
use App\Form\NouvelleDiscussionType;
use App\Repository\ContactRepository;
use App\Repository\DiscussionRepository;
use App\Repository\UtilisateurRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\CurrentUser;
use Symfony\Component\Security\Http\Attribute\IsCsrfTokenValid;

// Toutes les routes de ce contrôleur commencent par /discussions
#[Route('/discussions')]
class DiscussionController extends AbstractController
{
    #[Route('/nouvelle', name: 'app_discussion_nouvelle')]
    public function nouvelle(
        #[CurrentUser] Utilisateur $moi,
        Request $request,
        ContactRepository $contactRepository,
        EntityManagerInterface $entityManager,
    ): Response {
        $formulaire = $this->createForm(NouvelleDiscussionType::class, null, [
            'amis' => $contactRepository->findAmis($moi),
        ]);
        $formulaire->handleRequest($request);

        if ($formulaire->isSubmitted() && $formulaire->isValid()) {
            // Le formulaire renvoie une collection, on la transforme en tableau indexé 0, 1, 2...
            $membres = [...$formulaire->get('membres')->getData()];
            $nom = $formulaire->get('nom')->getData();

            // Un seul ami sans nom de groupe : c'est un MP
            if (1 === count($membres) && !$nom) {
                return $this->redirectToRoute('app_discussion_mp', ['id' => $membres[0]->getId()]);
            }

            if (!$nom) {
                $formulaire->get('nom')->addError(new FormError('Donne un nom au groupe.'));
            } else {
                $groupe = new Discussion();
                $groupe->setNom($nom);
                $groupe->addMembre($moi);
                foreach ($membres as $membre) {
                    $groupe->addMembre($membre);
                }

                $entityManager->persist($groupe);
                $entityManager->flush();

                return $this->redirectToRoute('app_discussion_voir', ['id' => $groupe->getId()]);
            }
        }

        return $this->render('_partials/formulaire_simple.html.twig', [
            'titre' => 'Nouvelle discussion',
            'formulaire' => $formulaire,
            'bouton' => 'Créer',
        ]);
    }

    // Ouvre le MP avec un ami, et le crée s'il n'existe pas encore
    #[Route('/mp/{id}', name: 'app_discussion_mp')]
    public function mp(
        #[CurrentUser] Utilisateur $moi,
        Utilisateur $ami,
        ContactRepository $contactRepository,
        DiscussionRepository $discussionRepository,
        EntityManagerInterface $entityManager,
    ): Response {
        if (!$contactRepository->sontAmis($moi, $ami)) {
            $this->addFlash('warning', 'Tu dois être ami avec cette personne pour lui écrire.');

            return $this->redirectToRoute('app_accueil');
        }

        $discussion = $discussionRepository->findMpEntre($moi, $ami);
        if (null === $discussion) {
            $discussion = new Discussion();
            $discussion->addMembre($moi);
            $discussion->addMembre($ami);
            $entityManager->persist($discussion);
            $entityManager->flush();
        }

        return $this->redirectToRoute('app_discussion_voir', ['id' => $discussion->getId()]);
    }

    #[Route('/{id}', name: 'app_discussion_voir', requirements: ['id' => '\d+'])]
    public function voir(
        #[CurrentUser] Utilisateur $moi,
        Discussion $discussion,
        Request $request,
        ContactRepository $contactRepository,
        EntityManagerInterface $entityManager,
    ): Response {
        $this->verifierMembre($discussion, $moi);

        $message = new Message();
        $formulaire = $this->createForm(MessageType::class, $message);
        $formulaire->handleRequest($request);

        if ($formulaire->isSubmitted() && $formulaire->isValid()) {
            $message->setAuteur($moi);
            $message->setDiscussion($discussion);
            $entityManager->persist($message);
            $entityManager->flush();

            // Redirection pour vider le formulaire et éviter un double envoi avec F5
            return $this->redirectToRoute('app_discussion_voir', ['id' => $discussion->getId()]);
        }

        return $this->render('discussion/voir.html.twig', [
            'discussion' => $discussion,
            'formulaire' => $formulaire,
            'amisAjoutables' => $contactRepository->findAmisNonMembres($moi, $discussion->getMembres()),
        ]);
    }

    // Juste la liste des messages, appelée toutes les 3 s par public/js/chat.js
    #[Route('/{id}/messages', name: 'app_discussion_messages')]
    public function messages(#[CurrentUser] Utilisateur $moi, Discussion $discussion): Response
    {
        $this->verifierMembre($discussion, $moi);

        return $this->render('message/_liste.html.twig', [
            'messages' => $discussion->getMessages(),
        ]);
    }

    #[Route('/{id}/modifier', name: 'app_discussion_modifier')]
    public function modifier(
        #[CurrentUser] Utilisateur $moi,
        Discussion $discussion,
        Request $request,
        EntityManagerInterface $entityManager,
    ): Response {
        $this->verifierMembre($discussion, $moi);
        if (!$discussion->estUnGroupe()) {
            throw $this->createNotFoundException('Un MP ne peut pas être renommé.');
        }

        $formulaire = $this->createForm(NomType::class, $discussion, ['data_class' => Discussion::class]);
        $formulaire->handleRequest($request);

        if ($formulaire->isSubmitted() && $formulaire->isValid()) {
            $entityManager->flush();

            return $this->redirectToRoute('app_discussion_voir', ['id' => $discussion->getId()]);
        }

        return $this->render('_partials/formulaire_simple.html.twig', [
            'titre' => 'Renommer le groupe',
            'formulaire' => $formulaire,
            'bouton' => 'Enregistrer',
        ]);
    }

    #[Route('/{id}/ajouter-membre', name: 'app_discussion_ajouter_membre', methods: ['POST'])]
    #[IsCsrfTokenValid('discussion')]
    public function ajouterMembre(
        #[CurrentUser] Utilisateur $moi,
        Discussion $discussion,
        Request $request,
        UtilisateurRepository $utilisateurRepository,
        ContactRepository $contactRepository,
        EntityManagerInterface $entityManager,
    ): Response {
        $this->verifierMembre($discussion, $moi);

        $ami = $utilisateurRepository->find($request->request->getInt('utilisateur'));
        if ($discussion->estUnGroupe() && $ami && $contactRepository->sontAmis($moi, $ami)) {
            $discussion->addMembre($ami);
            $entityManager->flush();
            $this->addFlash('success', $ami->getNomComplet().' a rejoint le groupe.');
        }

        return $this->redirectToRoute('app_discussion_voir', ['id' => $discussion->getId()]);
    }

    // Quitter un groupe, ou supprimer un MP
    #[Route('/{id}/quitter', name: 'app_discussion_quitter', methods: ['POST'])]
    #[IsCsrfTokenValid('discussion')]
    public function quitter(#[CurrentUser] Utilisateur $moi, Discussion $discussion, EntityManagerInterface $entityManager): Response
    {
        $this->verifierMembre($discussion, $moi);

        $discussion->removeMembre($moi);

        // Un MP ou un groupe vide est supprimé, ses messages partent avec (CASCADE)
        if (!$discussion->estUnGroupe() || $discussion->getMembres()->isEmpty()) {
            $entityManager->remove($discussion);
        }
        $entityManager->flush();

        return $this->redirectToRoute('app_accueil');
    }

    private function verifierMembre(Discussion $discussion, Utilisateur $moi): void
    {
        if (!$discussion->estMembre($moi)) {
            throw $this->createAccessDeniedException('Tu ne fais pas partie de cette discussion.');
        }
    }
}
