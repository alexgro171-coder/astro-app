import { IsNotEmpty, IsString, IsOptional, ValidateNested, IsDateString, IsNumber, Matches } from 'class-validator';
import { Type } from 'class-transformer';

export class PartnerBirthDataDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsNotEmpty()
  @IsDateString()
  birthDate: string;

  @IsOptional()
  @IsString()
  @Matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/, {
    message: 'Birth time must be in HH:MM format (24-hour)',
  })
  birthTime?: string;

  @IsOptional()
  @IsString()
  birthPlace?: string;

  @IsOptional()
  @IsNumber()
  birthLat?: number;

  @IsOptional()
  @IsNumber()
  birthLon?: number;

  @IsOptional()
  timezone?: number | string;
}

export class GenerateLoveCompatibilityDto {
  @IsNotEmpty()
  @ValidateNested()
  @Type(() => PartnerBirthDataDto)
  partner: PartnerBirthDataDto;

  @IsOptional()
  @IsString()
  locale?: string;
}

export class LoveCompatibilityResponseDto {
  status: 'PENDING' | 'READY' | 'FAILED';
  content?: string;
  errorMsg?: string;
  meta: {
    localeUsed: string;
    partnerName?: string;
    generatedAt?: string;
  };
}
