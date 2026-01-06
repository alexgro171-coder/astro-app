import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional, IsObject, IsString } from 'class-validator';
import { GenerationJobType } from '@prisma/client';

export class StartJobDto {
  @ApiProperty({
    enum: [
      'DAILY_GUIDANCE',
      'NATAL_CHART_SHORT',
      'NATAL_CHART_PRO',
      'KARMIC_ASTROLOGY',
      'ONE_TIME_REPORT',
    ],
    description: 'Type of generation job',
  })
  @IsEnum(GenerationJobType)
  jobType: GenerationJobType;

  @ApiPropertyOptional({
    description: 'Locale override (defaults to Accept-Language header or user preference)',
    example: 'en',
  })
  @IsOptional()
  @IsString()
  locale?: string;

  @ApiPropertyOptional({
    description: 'Additional payload data (required for ONE_TIME_REPORT)',
    example: { serviceType: 'LOVE_COMPATIBILITY_REPORT', partnerProfile: {} },
  })
  @IsOptional()
  @IsObject()
  payload?: Record<string, any>;
}

