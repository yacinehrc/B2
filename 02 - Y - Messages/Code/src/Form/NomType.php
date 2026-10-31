<?php

namespace App\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Validator\Constraints as Assert;

// Réutilisé pour un serveur, un salon ou un groupe : le contrôleur précise la classe avec 'data_class'
class NomType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder->add('nom', TextType::class, [
            'constraints' => [
                new Assert\NotBlank(message: 'Le nom est obligatoire.'),
                new Assert\Length(max: 100),
            ],
        ]);
    }
}
