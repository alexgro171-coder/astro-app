import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ScheduleModule } from '@nestjs/schedule';

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

@Module({
  imports: [
    // Configuration
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env.local', '.env'],
    }),

    // Scheduling (for daily guidance generation)
    ScheduleModule.forRoot(),

    // Core modules
    PrismaModule,
    HealthModule,
    
    // Feature modules
    AuthModule,
    UsersModule,
    AstrologyModule,
    AiModule,
    ConcernsModule,
    GuidanceModule,
    NotificationsModule,
  ],
})
export class AppModule {}

