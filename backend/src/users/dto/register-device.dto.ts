import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsEnum, IsOptional, IsNumber, IsInt } from 'class-validator';
import { Platform } from '@prisma/client';

export class RegisterDeviceDto {
  @ApiProperty({ 
    description: 'Stable device identifier (UUID or platform device ID)',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @IsString()
  deviceId: string;

  @ApiProperty({ enum: Platform })
  @IsEnum(Platform)
  platform: Platform;

  @ApiPropertyOptional({ 
    description: 'IANA timezone identifier from device',
    example: 'Europe/Bucharest',
  })
  @IsOptional()
  @IsString()
  timezoneIana?: string;

  @ApiPropertyOptional({ 
    description: 'UTC offset in minutes (e.g., 120 for UTC+2)',
    example: 120,
  })
  @IsOptional()
  @IsInt()
  utcOffsetMinutes?: number;

  @ApiPropertyOptional({ 
    description: 'FCM token for push notifications',
    example: 'eKjP_7fQTTCH...',
  })
  @IsOptional()
  @IsString()
  fcmToken?: string;

  @ApiPropertyOptional({ 
    description: 'Legacy device token (for backward compatibility)',
    deprecated: true,
  })
  @IsOptional()
  @IsString()
  deviceToken?: string;
}
