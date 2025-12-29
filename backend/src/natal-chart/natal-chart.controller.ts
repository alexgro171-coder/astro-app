import {
  Controller,
  Get,
  Post,
  Param,
  Query,
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
import { User } from '@prisma/client';

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
   * Returns interpretation in user's preferred language
   */
  @Get('interpretation/:planetKey')
  async getInterpretation(
    @CurrentUser() user: User,
    @Param('planetKey') planetKey: string,
  ) {
    this.logger.log(`Getting interpretation for ${planetKey} for user ${user.id} (lang: ${user.language})`);
    const interpretation = await this.natalChartService.getInterpretation(user.id, planetKey, user.language);
    
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
   * Generates in user's preferred language
   */
  @Post('pro/generate')
  async generateProInterpretations(@CurrentUser() user: User) {
    this.logger.log(`Generating pro interpretations for user ${user.id} (lang: ${user.language})`);
    
    const interpretations = await this.natalChartService.generateProInterpretations(user.id, user.language);
    
    return {
      message: 'Pro interpretations generated successfully',
      interpretations,
    };
  }

  /**
   * GET /natal-chart/wheel.svg - Get wheel chart as SVG
   * Query params:
   *   - force=true: Force regenerate SVG (ignore cache)
   */
  @Get('wheel.svg')
  async getWheelSvg(
    @CurrentUser('id') userId: string,
    @Query('force') force: string,
    @Res() res: Response,
  ) {
    const forceRegenerate = force === 'true';
    this.logger.log(`Getting wheel SVG for user ${userId}${forceRegenerate ? ' (force regenerate)' : ''}`);
    
    const svg = await this.renderService.getWheelSvg(userId, forceRegenerate);
    
    if (!svg) {
      return res.status(HttpStatus.NOT_FOUND).json({
        message: 'No natal chart data found.',
      });
    }

    res.setHeader('Content-Type', 'image/svg+xml');
    // Don't cache if force regenerated, otherwise cache for 1 day
    if (forceRegenerate) {
      res.setHeader('Cache-Control', 'no-cache');
    } else {
      res.setHeader('Cache-Control', 'public, max-age=86400');
    }
    return res.send(svg);
  }

  /**
   * POST /natal-chart/wheel/regenerate - Force regenerate wheel SVG
   */
  @Post('wheel/regenerate')
  async regenerateWheel(@CurrentUser('id') userId: string) {
    this.logger.log(`Force regenerating wheel SVG for user ${userId}`);
    await this.renderService.invalidateCache(userId);
    const svg = await this.renderService.getWheelSvg(userId, true);
    
    return {
      message: 'Wheel SVG regenerated successfully',
      hasWheel: !!svg,
    };
  }
}

