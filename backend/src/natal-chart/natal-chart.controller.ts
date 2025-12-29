import {
  Controller,
  Get,
  Post,
  Param,
  UseGuards,
  Res,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Response } from 'express';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { NatalChartService } from './natal-chart.service';
import { NatalChartRenderService } from './natal-chart-render.service';

@Controller('natal-chart')
@UseGuards(JwtAuthGuard)
export class NatalChartController {
  private readonly logger = new Logger(NatalChartController.name);

  constructor(
    private natalChartService: NatalChartService,
    private renderService: NatalChartRenderService,
  ) {}

  /**
   * GET /natal-chart - Get full natal chart data with interpretations
   */
  @Get()
  async getNatalChartData(@CurrentUser('id') userId: string) {
    this.logger.log(`Getting natal chart data for user ${userId}`);
    const data = await this.natalChartService.getNatalChartData(userId);
    
    if (!data) {
      return {
        statusCode: HttpStatus.NOT_FOUND,
        message: 'No natal chart data found. Please complete your birth data first.',
      };
    }

    return data;
  }

  /**
   * GET /natal-chart/placements - Get placements only
   */
  @Get('placements')
  async getPlacements(@CurrentUser('id') userId: string) {
    this.logger.log(`Getting placements for user ${userId}`);
    const placements = await this.natalChartService.getOrCreatePlacements(userId);
    
    if (!placements) {
      return {
        statusCode: HttpStatus.NOT_FOUND,
        message: 'No natal chart data found.',
      };
    }

    return placements.placementsJson;
  }

  /**
   * GET /natal-chart/interpretation/:planetKey - Get single interpretation (lazy load)
   */
  @Get('interpretation/:planetKey')
  async getInterpretation(
    @CurrentUser('id') userId: string,
    @Param('planetKey') planetKey: string,
  ) {
    this.logger.log(`Getting interpretation for ${planetKey} for user ${userId}`);
    const interpretation = await this.natalChartService.getInterpretation(userId, planetKey);
    
    if (!interpretation) {
      return {
        statusCode: HttpStatus.NOT_FOUND,
        message: `Interpretation for ${planetKey} not found.`,
      };
    }

    return interpretation;
  }

  /**
   * GET /natal-chart/interpretations/free - Get all FREE interpretations
   */
  @Get('interpretations/free')
  async getFreeInterpretations(@CurrentUser('id') userId: string) {
    this.logger.log(`Getting free interpretations for user ${userId}`);
    return this.natalChartService.getFreeInterpretations(userId);
  }

  /**
   * GET /natal-chart/interpretations/pro - Get all PRO interpretations
   */
  @Get('interpretations/pro')
  async getProInterpretations(@CurrentUser('id') userId: string) {
    this.logger.log(`Getting pro interpretations for user ${userId}`);
    
    const hasAccess = await this.natalChartService.hasProAccess(userId);
    if (!hasAccess) {
      return {
        statusCode: HttpStatus.FORBIDDEN,
        message: 'Pro access required. Please purchase the Pro Natal Chart.',
      };
    }

    return this.natalChartService.getProInterpretations(userId);
  }

  /**
   * GET /natal-chart/pro/status - Check if user has PRO access
   */
  @Get('pro/status')
  async getProStatus(@CurrentUser('id') userId: string) {
    const hasAccess = await this.natalChartService.hasProAccess(userId);
    return { hasAccess };
  }

  /**
   * POST /natal-chart/pro/generate - Generate PRO interpretations (after purchase)
   */
  @Post('pro/generate')
  async generateProInterpretations(@CurrentUser('id') userId: string) {
    this.logger.log(`Generating pro interpretations for user ${userId}`);
    
    const interpretations = await this.natalChartService.generateProInterpretations(userId);
    
    return {
      message: 'Pro interpretations generated successfully',
      interpretations,
    };
  }

  /**
   * GET /natal-chart/wheel.svg - Get wheel chart as SVG
   */
  @Get('wheel.svg')
  async getWheelSvg(@CurrentUser('id') userId: string, @Res() res: Response) {
    this.logger.log(`Getting wheel SVG for user ${userId}`);
    
    const svg = await this.renderService.getWheelSvg(userId);
    
    if (!svg) {
      return res.status(HttpStatus.NOT_FOUND).json({
        message: 'No natal chart data found.',
      });
    }

    res.setHeader('Content-Type', 'image/svg+xml');
    res.setHeader('Cache-Control', 'public, max-age=86400'); // Cache for 1 day
    return res.send(svg);
  }
}

