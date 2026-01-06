import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ForYouController } from './for-you.controller';
import { ForYouService } from './for-you.service';
import { AstrologyApiService } from './astrology-api.service';
import { TranslationService } from './translation.service';
import { PrismaModule } from '../prisma/prisma.module';
import { AnalyticsModule } from '../analytics/analytics.module';

@Module({
  imports: [ConfigModule, PrismaModule, AnalyticsModule],
  controllers: [ForYouController],
  providers: [ForYouService, AstrologyApiService, TranslationService],
  exports: [ForYouService],
})
export class ForYouModule {}

