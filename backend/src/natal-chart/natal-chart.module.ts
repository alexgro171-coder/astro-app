import { Module } from '@nestjs/common';
import { NatalChartController } from './natal-chart.controller';
import { NatalChartService } from './natal-chart.service';
import { NatalChartRenderService } from './natal-chart-render.service';
import { PrismaModule } from '../prisma/prisma.module';
import { AiModule } from '../ai/ai.module';

@Module({
  imports: [PrismaModule, AiModule],
  controllers: [NatalChartController],
  providers: [NatalChartService, NatalChartRenderService],
  exports: [NatalChartService],
})
export class NatalChartModule {}

