import { Module } from '@nestjs/common';
import { GuidanceService } from './guidance.service';
import { GuidanceController } from './guidance.controller';
import { GuidanceScheduler } from './guidance.scheduler';
import { AstrologyModule } from '../astrology/astrology.module';
import { AiModule } from '../ai/ai.module';
import { ConcernsModule } from '../concerns/concerns.module';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [AstrologyModule, AiModule, ConcernsModule, NotificationsModule],
  controllers: [GuidanceController],
  providers: [GuidanceService, GuidanceScheduler],
  exports: [GuidanceService],
})
export class GuidanceModule {}

