import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsOptional, Matches, IsDateString } from 'class-validator';

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

  @ApiProperty({ example: 'Bucharest, Romania', description: 'Birth place name' })
  @IsString()
  placeName: string;
}

