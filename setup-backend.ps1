Write-Host "Création + remplissage des fichiers backend..."

# Vérifier si backend existe
if (!(Test-Path "./backend/src")) {
    Write-Host "ERREUR: Le dossier backend/src n'existe pas."
    Write-Host "Crée d'abord le projet avec : nest new backend"
    exit
}

Set-Location ./backend/src

# --- DOMAIN ---
New-Item -ItemType Directory -Force -Path "domain/match/entities" | Out-Null
New-Item -ItemType Directory -Force -Path "domain/match/repositories" | Out-Null

# ENTITY
@"
export class Match {
  constructor(
    public readonly id: string,
    public readonly date: Date,
    public readonly teamA: string,
    public readonly teamB: string,
    public status: 'planned' | 'ongoing' | 'finished' = 'planned',
  ) {}
}
"@ | Set-Content "domain/match/entities/match.entity.ts"

# REPOSITORY INTERFACE
@"
import { Match } from '../entities/match.entity';

export abstract class MatchRepository {
  abstract create(match: Match): Promise<Match>;
  abstract findAll(): Promise<Match[]>;
}
"@ | Set-Content "domain/match/repositories/match.repository.ts"


# --- APPLICATION ---
New-Item -ItemType Directory -Force -Path "application/match/use-cases" | Out-Null
New-Item -ItemType Directory -Force -Path "application/match/dto" | Out-Null

# DTO
@"
import { IsString, IsDateString } from 'class-validator';

export class CreateMatchDto {
  @IsDateString()
  date: string;

  @IsString()
  teamA: string;

  @IsString()
  teamB: string;
}
"@ | Set-Content "application/match/dto/create-match.dto.ts"

# USE CASE
@"
import { MatchRepository } from '../../../domain/match/repositories/match.repository';
import { Match } from '../../../domain/match/entities/match.entity';
import { v4 as uuid } from 'uuid';

export class CreateMatchUseCase {
  constructor(private matchRepo: MatchRepository) {}

  async execute(data: { date: string; teamA: string; teamB: string }) {
    const match = new Match(
      uuid(),
      new Date(data.date),
      data.teamA,
      data.teamB,
      'planned',
    );

    return await this.matchRepo.create(match);
  }
}
"@ | Set-Content "application/match/use-cases/create-match.usecase.ts"


# --- INFRASTRUCTURE ---
New-Item -ItemType Directory -Force -Path "infrastructure/http/match" | Out-Null
New-Item -ItemType Directory -Force -Path "infrastructure/persistence/prisma" | Out-Null

# PRISMA SERVICE
@"
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
"@ | Set-Content "infrastructure/persistence/prisma/prisma.service.ts"


# PRISMA REPOSITORY IMPLEMENTATION
@"
import { Injectable } from '@nestjs/common';
import { PrismaService } from './prisma.service';
import { MatchRepository } from '../../../domain/match/repositories/match.repository';
import { Match } from '../../../domain/match/entities/match.entity';

@Injectable()
export class PrismaMatchRepository implements MatchRepository {
  constructor(private prisma: PrismaService) {}

  async create(match: Match): Promise<Match> {
    const record = await this.prisma.match.create({
      data: {
        id: match.id,
        date: match.date,
        teamA: match.teamA,
        teamB: match.teamB,
        status: match.status,
      },
    });

    return new Match(record.id, record.date, record.teamA, record.teamB, record.status as any);
  }

  async findAll(): Promise<Match[]> {
    const records = await this.prisma.match.findMany();

    return records.map(
      r => new Match(r.id, r.date, r.teamA, r.teamB, r.status as any),
    );
  }
}
"@ | Set-Content "infrastructure/persistence/prisma/prisma-match.repository.ts"


# CONTROLLER
@"
import { Body, Controller, Get, Post } from '@nestjs/common';
import { CreateMatchDto } from '../../../application/match/dto/create-match.dto';
import { CreateMatchUseCase } from '../../../application/match/use-cases/create-match.usecase';
import { MatchRepository } from '../../../domain/match/repositories/match.repository';

@Controller('matches')
export class MatchController {
  constructor(
    private readonly createMatchUseCase: CreateMatchUseCase,
    private readonly matchRepo: MatchRepository,
  ) {}

  @Post()
  async create(@Body() dto: CreateMatchDto) {
    return await this.createMatchUseCase.execute(dto);
  }

  @Get()
  async findAll() {
    return await this.matchRepo.findAll();
  }
}
"@ | Set-Content "infrastructure/http/match/match.controller.ts"


# MODULE
@"
import { Module } from '@nestjs/common';
import { MatchController } from './match.controller';
import { CreateMatchUseCase } from '../../../application/match/use-cases/create-match.usecase';
import { PrismaService } from '../../persistence/prisma/prisma.service';
import { PrismaMatchRepository } from '../../persistence/prisma/prisma-match.repository';
import { MatchRepository } from '../../../domain/match/repositories/match.repository';

@Module({
  controllers: [MatchController],
  providers: [
    PrismaService,
    {
      provide: MatchRepository,
      useClass: PrismaMatchRepository,
    },
    {
      provide: CreateMatchUseCase,
      useFactory: (repo: MatchRepository) => new CreateMatchUseCase(repo),
      inject: [MatchRepository],
    },
  ],
})
export class MatchModule {}
"@ | Set-Content "infrastructure/http/match/match.module.ts"

Write-Host "Fichiers créés et remplis avec succès."
