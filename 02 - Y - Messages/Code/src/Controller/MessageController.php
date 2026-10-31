<?php

namespace App\Controller;

use App\Entity\Message;
use App\Entity\Utilisateur;
use App\Form\MessageType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\CurrentUser;
use Symfony\Component\Security\Http\Attribute\IsCsrfTokenValid;

// L'envoi se fait dans DiscussionController et SalonController, ici on modifie et supprime
#[Route('/messages')]
class MessageController extends AbstractController
{
    #[Route('/{id}/modifier', name: 'app_message_modifier')]
    public function modifier(#[CurrentUser] Utilisateur $moi, Message $message, Request $request, EntityManagerInterface $entityManager): Response
    {
        $this->verifierAuteur($message, $moi);

        $formulaire = $this->createForm(MessageType::class, $message);
        $formulaire->handleRequest($request);

        if ($formulaire->isSubmitted() && $formulaire->isValid()) {
            $message->setModifieLe(new \DateTimeImmutable());
            $entityManager->flush();

            return $this->retourVersLaConversation($message);
        }

        return $this->render('_partials/formulaire_simple.html.twig', [
            'titre' => 'Modifier le message',
            'formulaire' => $formulaire,
            'bouton' => 'Enregistrer',
        ]);
    }

    #[Route('/{id}/supprimer', name: 'app_message_supprimer', methods: ['POST'])]
    #[IsCsrfTokenValid('message')]
    public function supprimer(#[CurrentUser] Utilisateur $moi, Message $message, EntityManagerInterface $entityManager): Response
    {
        $this->verifierAuteur($message, $moi);

        // On prépare la redirection avant, une fois supprimé on ne sait plus où il était
        $reponse = $this->retourVersLaConversation($message);

        $entityManager->remove($message);
        $entityManager->flush();

        return $reponse;
    }

    private function verifierAuteur(Message $message, Utilisateur $moi): void
    {
        if ($message->getAuteur() !== $moi) {
            throw $this->createAccessDeniedException('Ce message n\'est pas le tien.');
        }
    }

    private function retourVersLaConversation(Message $message): Response
    {
        if ($message->getDiscussion()) {
            return $this->redirectToRoute('app_discussion_voir', ['id' => $message->getDiscussion()->getId()]);
        }

        return $this->redirectToRoute('app_salon_voir', ['id' => $message->getSalon()->getId()]);
    }
}
