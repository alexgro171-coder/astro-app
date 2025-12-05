import { Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { AstrologyService } from './astrology.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { User } from '@prisma/client';

@ApiTags('astrology')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('astrology')
export class AstrologyController {
  constructor(private readonly astrologyService: AstrologyService) {}

  @Get('geo-search')
  @ApiOperation({ summary: 'Search for a location by name' })
  @ApiQuery({ name: 'place', required: true })
  async searchLocation(@Query('place') place: string): Promise<any> {
    const results = await this.astrologyService.getGeoDetails(place);
    return {
      results: results.slice(0, 10), // Limit to 10 results
    };
  }

  @Get('natal-chart')
  @ApiOperation({ summary: 'Get user natal chart' })
  async getNatalChart(@CurrentUser() user: User) {
    const chart = await this.astrologyService.getNatalChart(user.id);
    
    if (!chart) {
      return {
        hasChart: false,
        message: 'No natal chart found. Please set your birth data first.',
      };
    }

    return {
      hasChart: true,
      sunSign: chart.sunSign,
      moonSign: chart.moonSign,
      ascendant: chart.ascendant,
      summary: chart.summary,
      createdAt: chart.createdAt,
    };
  }

  @Get('transits/today')
  @ApiOperation({ summary: 'Get today\'s transits for the user' })
  async getTodayTransits(@CurrentUser() user: User) {
    const transits = await this.astrologyService.getDailyTransits(user, new Date());
    return {
      date: transits.date,
      transits: transits.transits,
    };
  }
}

