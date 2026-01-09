import { Module, forwardRef } from '@nestjs/common';
import { JobsController } from './jobs.controller';
import { JobsService } from './jobs.service';
import { JobQueueService } from './job-queue.service';
import { JobRunnerService } from './job-runner.service';
import { PrismaModule } from '../prisma/prisma.module';
import { GuidanceModule } from '../guidance/guidance.module';
import { ForYouModule } from '../for-you/for-you.module';
import { KarmicModule } from '../karmic/karmic.module';
import { AstrologyModule } from '../astrology/astrology.module';
import { NatalChartModule } from '../natal-chart/natal-chart.module';

@Module({
  imports: [
    PrismaModule,
    forwardRef(() => GuidanceModule),
    forwardRef(() => ForYouModule),
    forwardRef(() => KarmicModule),
    forwardRef(() => AstrologyModule),
    forwardRef(() => NatalChartModule),
  ],
  controllers: [JobsController],
  providers: [JobsService, JobQueueService, JobRunnerService],
  exports: [JobsService],
})
export class JobsModule {}

