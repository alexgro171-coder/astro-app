import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsEnum } from 'class-validator';
import { Platform } from '@prisma/client';

export class RegisterDeviceDto {
  @ApiProperty({ description: 'FCM or APNs device token' })
  @IsString()
  deviceToken: string;

  @ApiProperty({ enum: Platform })
  @IsEnum(Platform)
  platform: Platform;
}

