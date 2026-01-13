import { Module, forwardRef } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ForYouController } from './for-you.controller';
import { ForYouService } from './for-you.service';
import { AstrologyApiService } from './astrology-api.service';
import { TranslationService } from './translation.service';
import { LoveCompatibilityService } from './love-compatibility.service';
import { PrismaModule } from '../prisma/prisma.module';
import { AnalyticsModule } from '../analytics/analytics.module';
import { BillingModule } from '../billing/billing.module';
import { ContextModule } from '../context/context.module';

@Module({
  imports: [
    ConfigModule,
    PrismaModule,
    AnalyticsModule,
    forwardRef(() => BillingModule),
    forwardRef(() => ContextModule),
  ],
  controllers: [ForYouController],
  providers: [
    ForYouService,
    AstrologyApiService,
    TranslationService,
    LoveCompatibilityService,
  ],
  exports: [ForYouService, LoveCompatibilityService],
})
export class ForYouModule {}

