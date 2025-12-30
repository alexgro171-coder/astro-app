import { Module, forwardRef } from '@nestjs/common';
import { BullModule } from '@nestjs/bull';
import { GuidanceService } from './guidance.service';
import { GuidanceController } from './guidance.controller';
import { GuidanceScheduler } from './guidance.scheduler';
import { GuidanceQueueService } from './guidance-queue.service';
import { GuidanceQueueProcessor } from './guidance-queue.processor';
import { AstrologyModule } from '../astrology/astrology.module';
import { AiModule } from '../ai/ai.module';
import { ConcernsModule } from '../concerns/concerns.module';
import { NotificationsModule } from '../notifications/notifications.module';
import { ContextModule } from '../context/context.module';
import { BillingModule } from '../billing/billing.module';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [
    PrismaModule,
    AstrologyModule,
    AiModule,
    ConcernsModule,
    NotificationsModule,
    ContextModule,
    forwardRef(() => BillingModule),
    BullModule.registerQueue({
      name: 'guidance',
      defaultJobOptions: {
        attempts: 3,
        backoff: {
          type: 'exponential',
          delay: 5000,
        },
        removeOnComplete: 100,
        removeOnFail: 50,
      },
    }),
  ],
  controllers: [GuidanceController],
  providers: [
    GuidanceService,
    GuidanceScheduler,
    GuidanceQueueService,
    GuidanceQueueProcessor,
  ],
  exports: [GuidanceService, GuidanceQueueService],
})
export class GuidanceModule {}
