import {
  Controller,
  Get,
  Post,
  Param,
  Res,
  UseGuards,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiResponse } from '@nestjs/swagger';
import { Response } from 'express';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { User } from '@prisma/client';
import { TtsService } from './tts.service';
import { EntitlementsService } from '../billing/entitlements/entitlements.service';
import { PrismaService } from '../prisma/prisma.service';
import * as fs from 'fs';

@ApiTags('tts')
@Controller('guidance')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class TtsController {
  constructor(
    private ttsService: TtsService,
    private entitlementsService: EntitlementsService,
    private prisma: PrismaService,
  ) {}

  /**
   * Get audio for today's guidance
   * 
   * Premium only feature.
   * If audio doesn't exist, it will be queued for generation.
   */
  @Get('today/audio')
  @ApiOperation({ summary: 'Get audio URL for today\'s guidance (Premium only)' })
  @ApiResponse({ status: 200, description: 'Audio URL or generation status' })
  @ApiResponse({ status: 403, description: 'Premium subscription required' })
  async getTodayAudio(@CurrentUser() user: User) {
    // Check entitlements
    const entitlements = await this.entitlementsService.resolveEntitlements(user.id);
    
    if (!entitlements.canUseAudioTts) {
      throw new ForbiddenException({
        error: 'premium_required',
        message: 'Audio narration is a Premium feature',
        upgrade: true,
      });
    }

    // Get today's guidance
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const guidance = await this.prisma.dailyGuidance.findFirst({
      where: {
        userId: user.id,
        date: today,
      },
    });

    if (!guidance) {
      throw new NotFoundException('Today\'s guidance not found. Please generate guidance first.');
    }

    // Get or request audio
    const audioStatus = await this.ttsService.getAudioUrl(user.id, guidance.id);

    if (audioStatus.available) {
      return {
        available: true,
        audioUrl: audioStatus.audioUrl,
      };
    }

    // Request generation if not available
    const generationStatus = await this.ttsService.requestAudioGeneration(user.id, guidance.id);

    return {
      available: false,
      status: generationStatus.status,
      message: generationStatus.message,
    };
  }

  /**
   * Request audio generation for a specific guidance
   */
  @Post(':guidanceId/audio')
  @ApiOperation({ summary: 'Request audio generation for specific guidance' })
  async requestAudio(
    @CurrentUser() user: User,
    @Param('guidanceId') guidanceId: string,
  ) {
    // Check entitlements
    const entitlements = await this.entitlementsService.resolveEntitlements(user.id);
    
    if (!entitlements.canUseAudioTts) {
      throw new ForbiddenException({
        error: 'premium_required',
        message: 'Audio narration is a Premium feature',
      });
    }

    // Verify guidance belongs to user
    const guidance = await this.prisma.dailyGuidance.findFirst({
      where: {
        id: guidanceId,
        userId: user.id,
      },
    });

    if (!guidance) {
      throw new NotFoundException('Guidance not found');
    }

    return this.ttsService.requestAudioGeneration(user.id, guidanceId);
  }

  /**
   * Get audio status for a specific guidance
   */
  @Get(':guidanceId/audio')
  @ApiOperation({ summary: 'Get audio status for specific guidance' })
  async getAudioStatus(
    @CurrentUser() user: User,
    @Param('guidanceId') guidanceId: string,
  ) {
    const entitlements = await this.entitlementsService.resolveEntitlements(user.id);
    
    if (!entitlements.canUseAudioTts) {
      return {
        available: false,
        error: 'premium_required',
      };
    }

    return this.ttsService.getAudioUrl(user.id, guidanceId);
  }

  /**
   * Stream audio file (alternative to direct URL)
   * 
   * Use this if you need authenticated streaming instead of direct URLs.
   */
  @Get(':guidanceId/audio/stream')
  @ApiOperation({ summary: 'Stream audio file' })
  async streamAudio(
    @CurrentUser() user: User,
    @Param('guidanceId') guidanceId: string,
    @Res() res: Response,
  ) {
    const entitlements = await this.entitlementsService.resolveEntitlements(user.id);
    
    if (!entitlements.canUseAudioTts) {
      throw new ForbiddenException('Premium subscription required');
    }

    const audio = await this.prisma.guidanceAudio.findFirst({
      where: {
        guidanceId,
        userId: user.id,
        status: 'COMPLETED',
      },
    });

    if (!audio || !audio.filePath) {
      throw new NotFoundException('Audio not found');
    }

    // Verify file exists
    if (!fs.existsSync(audio.filePath)) {
      throw new NotFoundException('Audio file not found');
    }

    // Stream the file
    const stat = fs.statSync(audio.filePath);
    
    res.set({
      'Content-Type': 'audio/mpeg',
      'Content-Length': stat.size,
      'Content-Disposition': `inline; filename="guidance-${guidanceId}.mp3"`,
    });

    const readStream = fs.createReadStream(audio.filePath);
    readStream.pipe(res);
  }
}

