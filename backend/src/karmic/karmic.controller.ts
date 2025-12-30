import {
  Controller,
  Get,
  Post,
  Headers,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiHeader, ApiResponse } from '@nestjs/swagger';
import { KarmicService } from './karmic.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { User } from '@prisma/client';

@ApiTags('for-you')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('for-you/karmic')
export class KarmicController {
  constructor(private readonly karmicService: KarmicService) {}

  /**
   * GET /for-you/karmic
   * 
   * Get karmic astrology status and reading if available.
   * Returns beta free status, unlock status, and content if READY.
   */
  @Get()
  @ApiOperation({ 
    summary: 'Get karmic astrology status',
    description: 'Returns status flags, price, and reading content if available.',
  })
  @ApiHeader({
    name: 'Accept-Language',
    description: 'Preferred language (e.g., "en", "ro"). Falls back to user profile language.',
    required: false,
  })
  @ApiResponse({ 
    status: 200, 
    description: 'Karmic status with optional content',
    schema: {
      type: 'object',
      properties: {
        betaFree: { type: 'boolean' },
        priceUsd: { type: 'number' },
        locale: { type: 'string' },
        isUnlocked: { type: 'boolean' },
        status: { type: 'string', enum: ['READY', 'PENDING', 'NONE', 'FAILED'] },
        content: { type: 'string', nullable: true },
        errorMsg: { type: 'string', nullable: true },
      },
    },
  })
  async getKarmicStatus(
    @CurrentUser() user: User,
    @Headers('accept-language') acceptLanguage?: string,
  ) {
    return this.karmicService.getStatus(user, acceptLanguage);
  }

  /**
   * POST /for-you/karmic/generate
   * 
   * Generate karmic astrology reading.
   * Requires purchase or beta free mode.
   * Returns existing READY reading if available (idempotent).
   */
  @Post('generate')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ 
    summary: 'Generate karmic astrology reading',
    description: 'Generates a new karmic reading based on natal placements. Requires purchase or beta free access.',
  })
  @ApiHeader({
    name: 'Accept-Language',
    description: 'Preferred language for the reading.',
    required: false,
  })
  @ApiResponse({ 
    status: 200, 
    description: 'Reading generated successfully',
  })
  @ApiResponse({ 
    status: 403, 
    description: 'Purchase required (not in beta free mode)',
  })
  async generateKarmicReading(
    @CurrentUser() user: User,
    @Headers('accept-language') acceptLanguage?: string,
  ) {
    return this.karmicService.generateReading(user, acceptLanguage);
  }
}

