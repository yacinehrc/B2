<?php

namespace App\Form;

use App\Entity\Utilisateur;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints as Assert;

// Un ami coché = MP, plusieurs amis = groupe (le nom devient obligatoire)
class NouvelleDiscussionType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('membres', EntityType::class, [
                'class' => Utilisateur::class,
                'choices' => $options['amis'],
                'choice_label' => 'nomComplet',
                'multiple' => true,
                'expanded' => true, // cases à cocher plutôt qu'une liste déroulante
                'label' => 'Avec qui ?',
                'constraints' => [new Assert\Count(min: 1, minMessage: 'Choisis au moins un ami.')],
            ])
            ->add('nom', TextType::class, [
                'label' => 'Nom du groupe',
                'required' => false,
                'help' => 'Obligatoire seulement si tu choisis plusieurs amis.',
            ]);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        // La liste des amis est fournie par le contrôleur
        $resolver->setRequired('amis');
    }
}
