import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsOptional, IsEnum, IsBoolean, Matches } from 'class-validator';
import { Language } from '@prisma/client';

export class UpdateProfileDto {
  @ApiProperty({ required: false })
  @IsString()
  @IsOptional()
  name?: string;

  @ApiProperty({ enum: Language, required: false })
  @IsEnum(Language)
  @IsOptional()
  language?: Language;

  @ApiProperty({ required: false, example: 'Europe/Bucharest' })
  @IsString()
  @IsOptional()
  timezone?: string;

  @ApiProperty({ required: false, example: '09:00' })
  @IsString()
  @IsOptional()
  @Matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/, {
    message: 'notifyTime must be in HH:MM format',
  })
  notifyTime?: string;

  @ApiProperty({ required: false })
  @IsBoolean()
  @IsOptional()
  notifyEnabled?: boolean;
}

