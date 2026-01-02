import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ScheduleModule } from '@nestjs/schedule';
import { BullModule } from '@nestjs/bull';

// Core modules
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { AstrologyModule } from './astrology/astrology.module';
import { AiModule } from './ai/ai.module';
import { ConcernsModule } from './concerns/concerns.module';
import { GuidanceModule } from './guidance/guidance.module';
import { NotificationsModule } from './notifications/notifications.module';
import { HealthModule } from './health/health.module';
import { BillingModule } from './billing/billing.module';
import { OnboardingModule } from './onboarding/onboarding.module';
import { ContextModule } from './context/context.module';
import { AdminModule } from './admin/admin.module';
import { TtsModule } from './tts/tts.module';
import { NatalChartModule } from './natal-chart/natal-chart.module';
import { KarmicModule } from './karmic/karmic.module';
import { AnalyticsModule } from './analytics/analytics.module';
import { LearnModule } from './learn/learn.module';

@Module({
  imports: [
    // Configuration
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env.local', '.env'],
    }),

    // Scheduling (for daily guidance generation)
    ScheduleModule.forRoot(),

    // Queue for background jobs (TTS generation)
    BullModule.forRoot({
      redis: {
        host: process.env.REDIS_HOST || 'localhost',
        port: parseInt(process.env.REDIS_PORT || '6379'),
      },
    }),

    // Core modules
    PrismaModule,
    HealthModule,
    
    // Analytics (Global - available everywhere)
    AnalyticsModule,
    
    // Feature modules
    AuthModule,
    UsersModule,
    AstrologyModule,
    AiModule,
    ConcernsModule,
    GuidanceModule,
    NotificationsModule,
    
    // Monetization & Premium features
    BillingModule,
    OnboardingModule,
    ContextModule,
    TtsModule,
    
    // Administration
    AdminModule,
    
    // Natal Chart interpretations
    NatalChartModule,
    
    // For You features (Karmic Astrology, etc.)
    KarmicModule,
    
    // Learn CMS
    LearnModule,
  ],
})
export class AppModule {}

