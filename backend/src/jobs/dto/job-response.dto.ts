import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { GenerationJobStatus, GenerationJobType } from '@prisma/client';

export class JobStartResponse {
  @ApiProperty({ description: 'Unique job identifier' })
  jobId: string;

  @ApiProperty({
    enum: ['PENDING', 'RUNNING', 'READY', 'FAILED'],
    description: 'Current job status',
  })
  status: GenerationJobStatus;

  @ApiPropertyOptional({
    description: 'Reference to the result (when READY)',
    example: { kind: 'daily_guidance', localDateStr: '2026-01-06' },
  })
  resultRef?: Record<string, any>;

  @ApiPropertyOptional({
    description: 'Error message (when FAILED)',
  })
  errorMsg?: string;
}

export class JobStatusResponse {
  @ApiProperty({ description: 'Unique job identifier' })
  jobId: string;

  @ApiProperty({
    enum: ['DAILY_GUIDANCE', 'NATAL_CHART_SHORT', 'NATAL_CHART_PRO', 'KARMIC_ASTROLOGY', 'ONE_TIME_REPORT'],
    description: 'Type of generation job',
  })
  jobType: GenerationJobType;

  @ApiProperty({
    enum: ['PENDING', 'RUNNING', 'READY', 'FAILED'],
    description: 'Current job status',
  })
  status: GenerationJobStatus;

  @ApiPropertyOptional({
    description: 'Reference to the result (when READY)',
  })
  resultRef?: Record<string, any>;

  @ApiPropertyOptional({
    description: 'Error message (when FAILED)',
  })
  errorMsg?: string;

  @ApiPropertyOptional({
    description: 'Human-friendly progress hint',
    example: 'Reading the stars...',
  })
  progressHint?: string;
}

