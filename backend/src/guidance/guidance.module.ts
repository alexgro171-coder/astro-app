import { Module, forwardRef } from '@nestjs/common';
import { GuidanceService } from './guidance.service';
import { GuidanceController } from './guidance.controller';
import { GuidanceScheduler } from './guidance.scheduler';
import { AstrologyModule } from '../astrology/astrology.module';
import { AiModule } from '../ai/ai.module';
import { ConcernsModule } from '../concerns/concerns.module';
import { NotificationsModule } from '../notifications/notifications.module';
import { ContextModule } from '../context/context.module';
import { BillingModule } from '../billing/billing.module';

@Module({
  imports: [
    AstrologyModule,
    AiModule,
    ConcernsModule,
    NotificationsModule,
    ContextModule,
    forwardRef(() => BillingModule), // forwardRef to avoid circular dependency
  ],
  controllers: [GuidanceController],
  providers: [GuidanceService, GuidanceScheduler],
  exports: [GuidanceService],
})
export class GuidanceModule {}

