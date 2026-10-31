<?php

namespace App\Controller;

use App\Entity\Utilisateur;
use App\Form\ProfilType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\CurrentUser;
use Symfony\Component\Security\Http\Attribute\IsCsrfTokenValid;

#[Route('/profil')]
class ProfilController extends AbstractController
{
    #[Route('', name: 'app_profil')]
    public function monProfil(#[CurrentUser] Utilisateur $moi): Response
    {
        return $this->render('profil/voir.html.twig', ['utilisateur' => $moi]);
    }

    #[Route('/{id}', name: 'app_profil_voir', requirements: ['id' => '\d+'])]
    public function voir(Utilisateur $utilisateur): Response
    {
        return $this->render('profil/voir.html.twig', ['utilisateur' => $utilisateur]);
    }

    #[Route('/modifier', name: 'app_profil_modifier')]
    public function modifier(
        #[CurrentUser] Utilisateur $moi,
        Request $request,
        UserPasswordHasherInterface $hasher,
        EntityManagerInterface $entityManager,
    ): Response {
        $formulaire = $this->createForm(ProfilType::class, $moi);
        $formulaire->handleRequest($request);

        if ($formulaire->isSubmitted() && $formulaire->isValid()) {
            $fichier = $formulaire->get('fichierAvatar')->getData();
            if ($fichier) {
                $dossier = $this->getParameter('kernel.project_dir').'/public/uploads/avatars';
                // Nom unique pour ne jamais écraser l'image de quelqu'un d'autre
                $nomFichier = uniqid('avatar_').'.'.$fichier->guessExtension();
                $fichier->move($dossier, $nomFichier);

                if ($moi->getAvatar() && is_file($dossier.'/'.$moi->getAvatar())) {
                    unlink($dossier.'/'.$moi->getAvatar());
                }
                $moi->setAvatar($nomFichier);
            }

            $nouveauMotDePasse = $formulaire->get('nouveauMotDePasse')->getData();
            if ($nouveauMotDePasse) {
                $moi->setMotDePasse($hasher->hashPassword($moi, $nouveauMotDePasse));
            }

            $entityManager->flush();
            $this->addFlash('success', 'Profil mis à jour !');

            return $this->redirectToRoute('app_profil');
        }

        if ($formulaire->isSubmitted()) {
            // On annule les valeurs invalides restées en mémoire, sinon Symfony
            // croirait que l'identifiant a changé et nous déconnecterait
            $entityManager->refresh($moi);
        }

        return $this->render('profil/modifier.html.twig', [
            'formulaire' => $formulaire,
        ]);
    }

    // Les messages, contacts et serveurs du compte sont supprimés par la base (CASCADE)
    #[Route('/supprimer', name: 'app_profil_supprimer', methods: ['POST'])]
    #[IsCsrfTokenValid('supprimer_compte')]
    public function supprimer(#[CurrentUser] Utilisateur $moi, EntityManagerInterface $entityManager, Security $security): Response
    {
        $avatar = $this->getParameter('kernel.project_dir').'/public/uploads/avatars/'.$moi->getAvatar();
        if ($moi->getAvatar() && is_file($avatar)) {
            unlink($avatar);
        }

        // false = pas besoin du jeton CSRF de déconnexion ici
        $security->logout(false);

        $entityManager->remove($moi);
        $entityManager->flush();

        return $this->redirectToRoute('app_connexion');
    }
}
