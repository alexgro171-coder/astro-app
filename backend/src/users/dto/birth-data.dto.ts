import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsOptional, Matches, IsDateString, IsNumber, ValidateNested, IsIn } from 'class-validator';
import { Type } from 'class-transformer';

// Gender values matching Prisma enum
const GENDER_VALUES = ['MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY'] as const;
type GenderType = typeof GENDER_VALUES[number];

/**
 * Location data selected from autocomplete
 */
export class SelectedLocationDto {
  @ApiProperty({ example: 'San Jose', description: 'City/Place name' })
  @IsString()
  placeName: string;

  @ApiProperty({ example: 'California', description: 'State/Region name', required: false })
  @IsString()
  @IsOptional()
  adminName?: string;

  @ApiProperty({ example: 'United States', description: 'Country name' })
  @IsString()
  countryName: string;

  @ApiProperty({ example: 'US', description: 'Country code (ISO 2-letter)' })
  @IsString()
  countryCode: string;

  @ApiProperty({ example: 37.3382, description: 'Latitude' })
  @IsNumber()
  latitude: number;

  @ApiProperty({ example: -121.8863, description: 'Longitude' })
  @IsNumber()
  longitude: number;

  @ApiProperty({ example: 'America/Los_Angeles', description: 'Timezone ID', required: false })
  @IsString()
  @IsOptional()
  timezoneId?: string;
}

export class BirthDataDto {
  @ApiProperty({ example: '1990-05-15', description: 'Birth date in YYYY-MM-DD format' })
  @IsDateString()
  birthDate: string;

  @ApiProperty({
    example: '14:30',
    description: 'Birth time in HH:MM format, or "unknown"',
    required: false,
  })
  @IsString()
  @IsOptional()
  @Matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$|^unknown$/, {
    message: 'birthTime must be in HH:MM format or "unknown"',
  })
  birthTime?: string;

  @ApiProperty({ 
    example: 'Bucharest, Romania', 
    description: 'Birth place name (legacy - use location instead)',
    required: false,
  })
  @IsString()
  @IsOptional()
  placeName?: string;

  @ApiProperty({ 
    description: 'Pre-resolved location from autocomplete selection',
    required: false,
    type: SelectedLocationDto,
  })
  @ValidateNested()
  @Type(() => SelectedLocationDto)
  @IsOptional()
  location?: SelectedLocationDto;

  @ApiProperty({
    enum: GENDER_VALUES,
    description: 'User gender for personalized guidance',
    required: false,
  })
  @IsIn(GENDER_VALUES)
  @IsOptional()
  gender?: GenderType;
}

