
mkdir -p domain/match/entities
mkdir -p domain/match/value-objects
mkdir -p domain/match/services
mkdir -p domain/match/repositories


mkdir -p application/match/use-cases
mkdir -p application/match/dto


mkdir -p infrastructure/persistence/prisma
mkdir -p infrastructure/http/match
mkdir -p infrastructure/http/auth


mkdir -p shared/utils
mkdir -p shared/exceptions


touch domain/match/entities/.gitkeep
touch domain/match/repositories/.gitkeep
touch application/match/use-cases/.gitkeep
touch infrastructure/persistence/prisma/.gitkeep


touch infrastructure/http/match/match.module.ts
touch infrastructure/http/match/match.controller.ts
touch infrastructure/persistence/prisma/prisma.service.ts
touch infrastructure/persistence/prisma/prisma-match.repository.ts

echo "✅ Arborescence créée avec succès !"
