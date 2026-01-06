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

  // Location fields - supporting both old and new naming conventions
  @ApiPropertyOptional({ example: 'New York', description: 'Birth city name' })
  @IsOptional()
  @IsString()
  birthCity?: string;

  @ApiPropertyOptional({ example: 'United States', description: 'Birth country name' })
  @IsOptional()
  @IsString()
  birthCountry?: string;

  @ApiPropertyOptional({ example: 'US', description: 'Birth country ISO code' })
  @IsOptional()
  @IsString()
  birthCountryCode?: string;

  @ApiPropertyOptional({ example: 40.7128, description: 'Birth place latitude' })
  @IsOptional()
  @IsNumber()
  birthLat?: number;

  @ApiPropertyOptional({ example: -74.006, description: 'Birth place longitude' })
  @IsOptional()
  @IsNumber()
  birthLon?: number;

  @ApiPropertyOptional({ example: 'America/New_York', description: 'Birth timezone IANA identifier' })
  @IsOptional()
  @IsString()
  birthTimezone?: string;

  // Legacy fields for backwards compatibility
  @ApiPropertyOptional({ example: 'New York', deprecated: true })
  @IsOptional()
  @IsString()
  city?: string;

  @ApiPropertyOptional({ example: 'USA', deprecated: true })
  @IsOptional()
  @IsString()
  country?: string;

  @ApiPropertyOptional({ example: 40.7128, deprecated: true })
  @IsOptional()
  @IsNumber()
  lat?: number;

  @ApiPropertyOptional({ example: -74.006, deprecated: true })
  @IsOptional()
  @IsNumber()
  lon?: number;

  @ApiPropertyOptional({ example: -5, description: 'Timezone offset in hours (deprecated, use birthTimezone)' })
  @IsOptional()
  @IsNumber()
  timezone?: number;

  /**
   * Get normalized birth location data.
   * Prefers new field names over legacy ones.
   */
  getNormalizedLocation(): {
    city?: string;
    country?: string;
    countryCode?: string;
    lat?: number;
    lon?: number;
    timezone?: string;
    timezoneOffset?: number;
  } {
    return {
      city: this.birthCity || this.city,
      country: this.birthCountry || this.country,
      countryCode: this.birthCountryCode,
      lat: this.birthLat ?? this.lat,
      lon: this.birthLon ?? this.lon,
      timezone: this.birthTimezone,
      timezoneOffset: this.timezone,
    };
  }
}
