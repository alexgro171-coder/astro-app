import { Module } from '@nestjs/common';
import { ConcernsService } from './concerns.service';
import { ConcernsController } from './concerns.controller';
import { AiModule } from '../ai/ai.module';

@Module({
  imports: [AiModule],
  controllers: [ConcernsController],
  providers: [ConcernsService],
  exports: [ConcernsService],
})
export class ConcernsModule {}

