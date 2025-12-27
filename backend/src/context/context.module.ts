import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ContextController } from './context.controller';
import { ContextService } from './context.service';
import { ContextSummarizerService } from './context-summarizer.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule, ConfigModule],
  controllers: [ContextController],
  providers: [ContextService, ContextSummarizerService],
  exports: [ContextService, ContextSummarizerService],
})
export class ContextModule {}

