import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { AstrologyService } from './astrology.service';
import { AstrologyController } from './astrology.controller';

@Module({
  imports: [
    HttpModule.register({
      timeout: 30000,
      maxRedirects: 5,
    }),
  ],
  controllers: [AstrologyController],
  providers: [AstrologyService],
  exports: [AstrologyService],
})
export class AstrologyModule {}

