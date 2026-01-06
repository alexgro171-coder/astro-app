import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsDateString,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Matches,
} from 'class-validator';

export class PartnerProfileDto {
  @ApiPropertyOptional({ example: 'John' })
  @IsOptional()
  @IsString()
  name?: string;

  @ApiProperty({ example: '1990-05-15', description: 'Birth date in YYYY-MM-DD format' })
  @IsNotEmpty()
  @IsDateString()
  birthDate: string;

  @ApiPropertyOptional({ example: '14:30', description: 'Birth time in HH:MM format (24h)' })
  @IsOptional()
  @IsString()
  @Matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/, {
    message: 'Birth time must be in HH:MM format (24-hour)',
  })
  birthTime?: string;

  @ApiPropertyOptional({ example: 'New York' })
  @IsOptional()
  @IsString()
  city?: string;

  @ApiPropertyOptional({ example: 'USA' })
  @IsOptional()
  @IsString()
  country?: string;

  @ApiPropertyOptional({ example: 40.7128, description: 'Latitude' })
  @IsOptional()
  @IsNumber()
  lat?: number;

  @ApiPropertyOptional({ example: -74.006, description: 'Longitude' })
  @IsOptional()
  @IsNumber()
  lon?: number;

  @ApiPropertyOptional({ example: -5, description: 'Timezone offset in hours from UTC' })
  @IsOptional()
  @IsNumber()
  timezone?: number;
}

