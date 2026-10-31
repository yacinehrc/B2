<?php

namespace App\Form;

use App\Entity\Utilisateur;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\PasswordType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints as Assert;

class ProfilType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('identifiant', TextType::class, [
                'help' => 'Sert à te connecter et à être ajouté en ami.',
                'constraints' => [
                    new Assert\NotBlank(),
                    new Assert\Length(min: 3, max: 50),
                    new Assert\Regex('/^[a-z0-9_]+$/', message: 'Seulement des minuscules, chiffres et "_".'),
                ],
            ])
            ->add('prenom', TextType::class, ['label' => 'Prénom'])
            ->add('nom', TextType::class)
            ->add('bio', TextareaType::class, [
                'required' => false,
                'attr' => ['rows' => 3, 'placeholder' => 'Parle un peu de toi...'],
            ])
            // Non mappé : on ne stocke que le nom du fichier, c'est le contrôleur qui le gère
            ->add('fichierAvatar', FileType::class, [
                'label' => 'Avatar (image, 2 Mo max)',
                'mapped' => false,
                'required' => false,
                'constraints' => [
                    new Assert\Image(maxSize: '2M', mimeTypesMessage: 'Envoie une image (jpg, png, gif...).'),
                ],
            ])
            // Laissé vide = on garde l'ancien mot de passe
            ->add('nouveauMotDePasse', PasswordType::class, [
                'label' => 'Nouveau mot de passe',
                'mapped' => false,
                'required' => false,
                'help' => 'Laisse vide pour ne pas le changer.',
                'constraints' => [new Assert\Length(min: 6)],
            ]);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults(['data_class' => Utilisateur::class]);
    }
}
