<?php

namespace App;

use Symfony\Bundle\FrameworkBundle\Kernel\MicroKernelTrait;
use Symfony\Component\HttpKernel\Kernel as BaseKernel;

class Kernel extends BaseKernel
{
    use MicroKernelTrait;

    // Valeurs autorisées pour APP_ENV dans le .env
    private function getAllowedEnvs(): array
    {
        return ['prod', 'dev', 'test'];
    }
}
