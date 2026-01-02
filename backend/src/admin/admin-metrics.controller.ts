import { Controller, Get, Query, UseGuards, BadRequestException } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { AdminGuard } from './guards/admin.guard';
import { AnalyticsService } from '../analytics/analytics.service';

@ApiTags('Admin - Metrics')
@ApiBearerAuth()
@Controller('admin/metrics')
@UseGuards(AdminGuard)
export class AdminMetricsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Get('overview')
  @ApiOperation({ summary: 'Get dashboard metrics overview' })
  @ApiQuery({ name: 'range', enum: ['1d', '7d', '30d', '90d'], required: true })
  async getOverview(@Query('range') range: string) {
    const validRanges = ['1d', '7d', '30d', '90d'];
    if (!validRanges.includes(range)) {
      throw new BadRequestException(`Invalid range. Must be one of: ${validRanges.join(', ')}`);
    }

    return this.analyticsService.queryMetrics(range as '1d' | '7d' | '30d' | '90d');
  }
}

