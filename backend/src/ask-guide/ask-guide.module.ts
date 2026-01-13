import { Module, forwardRef } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AskGuideController } from './ask-guide.controller';
import { AskGuideService } from './ask-guide.service';
import { PrismaModule } from '../prisma/prisma.module';
import { AstrologyModule } from '../astrology/astrology.module';
import { ContextModule } from '../context/context.module';
import { BillingModule } from '../billing/billing.module';

@Module({
  imports: [
    ConfigModule,
    PrismaModule,
    forwardRef(() => AstrologyModule),
    forwardRef(() => ContextModule),
    forwardRef(() => BillingModule),
  ],
  controllers: [AskGuideController],
  providers: [AskGuideService],
  exports: [AskGuideService],
})
export class AskGuideModule {}
