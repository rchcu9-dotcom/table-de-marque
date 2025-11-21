Write-Host "Création de l'arborescence du backend..."

# Vérification du dossier backend
if (!(Test-Path "./backend")) {
    Write-Host "ERREUR : Le dossier backend/ n'existe pas."
    Write-Host "Exécute d'abord la commande : nest new backend"
    exit
}

Set-Location ./backend/src

# DOMAIN
New-Item -ItemType Directory -Force -Path "domain/match/entities" | Out-Null
New-Item -ItemType Directory -Force -Path "domain/match/value-objects" | Out-Null
New-Item -ItemType Directory -Force -Path "domain/match/services" | Out-Null
New-Item -ItemType Directory -Force -Path "domain/match/repositories" | Out-Null

# APPLICATION
New-Item -ItemType Directory -Force -Path "application/match/use-cases" | Out-Null
New-Item -ItemType Directory -Force -Path "application/match/dto" | Out-Null

# INFRASTRUCTURE
New-Item -ItemType Directory -Force -Path "infrastructure/persistence/prisma" | Out-Null
New-Item -ItemType Directory -Force -Path "infrastructure/http/match" | Out-Null
New-Item -ItemType Directory -Force -Path "infrastructure/http/auth" | Out-Null

# SHARED
New-Item -ItemType Directory -Force -Path "shared/utils" | Out-Null
New-Item -ItemType Directory -Force -Path "shared/exceptions" | Out-Null

# FICHIERS VIDES (placeholders)
New-Item -ItemType File -Force -Path "domain/match/entities/.gitkeep" | Out-Null
New-Item -ItemType File -Force -Path "domain/match/repositories/.gitkeep" | Out-Null
New-Item -ItemType File -Force -Path "application/match/use-cases/.gitkeep" | Out-Null
New-Item -ItemType File -Force -Path "infrastructure/persistence/prisma/.gitkeep" | Out-Null

# MODULES & SERVICES
New-Item -ItemType File -Force -Path "infrastructure/http/match/match.module.ts" | Out-Null
New-Item -ItemType File -Force -Path "infrastructure/http/match/match.controller.ts" | Out-Null
New-Item -ItemType File -Force -Path "infrastructure/persistence/prisma/prisma.service.ts" | Out-Null
New-Item -ItemType File -Force -Path "infrastructure/persistence/prisma/prisma-match.repository.ts" | Out-Null

Write-Host "Arborescence créée avec succès."
