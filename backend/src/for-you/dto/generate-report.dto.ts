import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsDateString,
  IsIn,
  IsOptional,
  IsString,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { PartnerProfileDto } from './partner-profile.dto';
import { SUPPORTED_LOCALES } from '../service-catalog';

export class GenerateReportDto {
  @ApiPropertyOptional({
    example: 'en',
    description: 'Target language for the report',
    enum: SUPPORTED_LOCALES,
  })
  @IsOptional()
  @IsString()
  @IsIn(SUPPORTED_LOCALES)
  locale?: string;

  @ApiPropertyOptional({
    description: 'Partner profile data (required for compatibility reports)',
    type: PartnerProfileDto,
  })
  @IsOptional()
  @ValidateNested()
  @Type(() => PartnerProfileDto)
  partnerProfile?: PartnerProfileDto;

  @ApiPropertyOptional({
    example: '2024-01-15',
    description: 'Date for date-based reports (e.g., Moon Phase). Defaults to today.',
  })
  @IsOptional()
  @IsDateString()
  date?: string;
}

