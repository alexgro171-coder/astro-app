import {
  Controller,
  Get,
  Post,
  Param,
  Query,
  Body,
  Headers,
  UseGuards,
  ParseEnumPipe,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiParam,
  ApiQuery,
  ApiResponse,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { ForYouService } from './for-you.service';
import { LoveCompatibilityService } from './love-compatibility.service';
import { GenerateReportDto } from './dto/generate-report.dto';
import {
  GenerateLoveCompatibilityDto,
  LoveCompatibilityResponseDto,
} from './dto/love-compatibility.dto';
import {
  CatalogResponseDto,
  ReportResponseDto,
} from './dto/catalog-response.dto';
import { OneTimeServiceType, User } from '@prisma/client';

@ApiTags('For You')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('for-you')
export class ForYouController {
  constructor(
    private readonly forYouService: ForYouService,
    private readonly loveCompatibilityService: LoveCompatibilityService,
  ) {}

  @Get('catalog')
  @ApiOperation({ summary: 'Get available one-time services catalog' })
  @ApiResponse({
    status: 200,
    description: 'Returns catalog with services and unlock status',
    type: CatalogResponseDto,
  })
  async getCatalog(@CurrentUser('id') userId: string): Promise<CatalogResponseDto> {
    return this.forYouService.getCatalog(userId);
  }

  @Get('reports/:serviceType')
  @ApiOperation({ summary: 'Get existing report status and content' })
  @ApiParam({
    name: 'serviceType',
    enum: OneTimeServiceType,
    description: 'Type of service',
  })
  @ApiQuery({
    name: 'locale',
    required: false,
    description: 'Language code (en, ro, fr, etc.)',
  })
  @ApiQuery({
    name: 'partnerHash',
    required: false,
    description: 'Partner data hash for couple reports',
  })
  @ApiQuery({
    name: 'date',
    required: false,
    description: 'Date for date-based reports (YYYY-MM-DD)',
  })
  @ApiResponse({
    status: 200,
    description: 'Returns report status (NONE, PENDING, READY, FAILED) and content if available',
    type: ReportResponseDto,
  })
  async getReport(
    @CurrentUser('id') userId: string,
    @Param('serviceType', new ParseEnumPipe(OneTimeServiceType))
    serviceType: OneTimeServiceType,
    @Query('locale') locale?: string,
    @Query('partnerHash') partnerHash?: string,
    @Query('date') date?: string,
    @Headers('accept-language') acceptLanguage?: string,
  ): Promise<ReportResponseDto> {
    const resolvedLocale = locale || acceptLanguage?.split(',')[0]?.split('-')[0] || 'en';
    return this.forYouService.getReport(
      userId,
      serviceType,
      resolvedLocale,
      partnerHash,
      date,
    );
  }

  @Post('reports/:serviceType/generate')
  @ApiOperation({ summary: 'Generate a one-time report (idempotent)' })
  @ApiParam({
    name: 'serviceType',
    enum: OneTimeServiceType,
    description: 'Type of service',
  })
  @ApiResponse({
    status: 200,
    description: 'Returns generated report or existing if already generated',
  })
  @ApiResponse({
    status: 400,
    description: 'Bad request (missing partner data, missing birth data)',
  })
  @ApiResponse({
    status: 403,
    description: 'Purchase required (not in beta mode and not purchased)',
  })
  async generateReport(
    @CurrentUser('id') userId: string,
    @Param('serviceType', new ParseEnumPipe(OneTimeServiceType))
    serviceType: OneTimeServiceType,
    @Body() dto: GenerateReportDto,
    @Headers('accept-language') acceptLanguage?: string,
  ): Promise<ReportResponseDto> {
    return this.forYouService.generateReport(
      userId,
      serviceType,
      dto,
      acceptLanguage,
    );
  }

  /**
   * Generate Love Compatibility Analysis with OpenAI
   * 
   * This endpoint:
   * 1. Gets partner's natal chart from AstrologyAPI (not saved)
   * 2. Combines with user's natal chart
   * 3. Sends to OpenAI for comprehensive analysis
   * 
   * Partner data is NEVER stored permanently.
   */
  @Post('love-compatibility')
  @ApiOperation({ summary: 'Generate AI-powered love compatibility analysis' })
  @ApiResponse({
    status: 200,
    description: 'Returns comprehensive compatibility analysis',
  })
  @ApiResponse({
    status: 400,
    description: 'Missing birth data or partner data',
  })
  @ApiResponse({
    status: 403,
    description: 'Active subscription required',
  })
  async generateLoveCompatibility(
    @CurrentUser() user: User,
    @Body() dto: GenerateLoveCompatibilityDto,
    @Headers('accept-language') acceptLanguage?: string,
  ): Promise<LoveCompatibilityResponseDto> {
    return this.loveCompatibilityService.generateCompatibility(
      user,
      dto,
      acceptLanguage,
    );
  }
}

