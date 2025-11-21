#!/bin/bash

# Se placer dans le dossier racine du projet
cd "$(dirname "$0")"

echo "📁 Création de l'arborescence du backend..."

# Si le dossier backend n'existe pas, on prévient
if [ ! -d "backend" ]; then
  echo "❌ Le dossier backend/ n'existe pas."
  echo "➡️ Exécute d'abord : nest new backend"
  exit 1
fi

cd backend/src

# Domain
mkdir -p domain/match/entities
mkdir -p domain/match/value-objects
mkdir -p domain/match/services
mkdir -p domain/match/repositories

# Application layer
mkdir -p application/match/use-cases
mkdir -p application/match/dto

# Infrastructure
mkdir -p infrastructure/persistence/prisma
mkdir -p infrastructure/http/match
mkdir -p infrastructure/http/auth

# Shared
mkdir -p shared/utils
mkdir -p shared/exceptions

# Création de fichiers vides (placeholder)
touch domain/match/entities/.gitkeep
touch domain/match/repositories/.gitkeep
touch application/match/use-cases/.gitkeep
touch infrastructure/persistence/prisma/.gitkeep

# Modules NestJS
touch infrastructure/http/match/match.module.ts
touch infrastructure/http/match/match.controller.ts
touch infrastructure/persistence/prisma/prisma.service.ts
touch infrastructure/persistence/prisma/prisma-match.repository.ts

echo "✅ Arborescence créée avec succès !"
