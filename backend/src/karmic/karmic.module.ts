import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from '../prisma/prisma.module';
import { AiModule } from '../ai/ai.module';
import { KarmicService } from './karmic.service';
import { KarmicController } from './karmic.controller';

/**
 * Karmic Astrology Module
 * 
 * Provides karmic astrology readings based on:
 * - North/South Node placement
 * - Retrograde planets
 * 
 * Features:
 * - Beta free access (controlled by KARMIC_BETA_FREE env)
 * - One-time purchase gating (for production)
 * - Multi-language support
 * - Standard/Extended prompt variants
 */
@Module({
  imports: [
    ConfigModule,
    PrismaModule,
    AiModule,
  ],
  controllers: [KarmicController],
  providers: [KarmicService],
  exports: [KarmicService],
})
export class KarmicModule {}

