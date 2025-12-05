import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { GuidanceService } from './guidance.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { FeedbackDto } from './dto/feedback.dto';
import { User } from '@prisma/client';

@ApiTags('guidance')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('guidance')
export class GuidanceController {
  constructor(private readonly guidanceService: GuidanceService) {}

  @Get('today')
  @ApiOperation({ summary: 'Get today\'s guidance' })
  async getTodayGuidance(@CurrentUser() user: User) {
    return this.guidanceService.getTodayGuidance(user);
  }

  @Get('history')
  @ApiOperation({ summary: 'Get guidance history' })
  @ApiQuery({ name: 'from', required: false, type: String })
  @ApiQuery({ name: 'to', required: false, type: String })
  async getHistory(
    @CurrentUser() user: User,
    @Query('from') from?: string,
    @Query('to') to?: string,
  ) {
    return this.guidanceService.getHistory(
      user.id,
      from ? new Date(from) : undefined,
      to ? new Date(to) : undefined,
    );
  }

  @Post(':id/feedback')
  @ApiOperation({ summary: 'Submit feedback for a guidance' })
  async submitFeedback(
    @CurrentUser() user: User,
    @Param('id') id: string,
    @Body() feedbackDto: FeedbackDto,
  ) {
    return this.guidanceService.submitFeedback(user.id, id, feedbackDto);
  }

  @Post('regenerate')
  @ApiOperation({ summary: 'Force regenerate today\'s guidance' })
  async regenerateGuidance(@CurrentUser() user: User) {
    return this.guidanceService.generateGuidance(user, new Date());
  }
}

