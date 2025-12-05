import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsOptional, IsEnum, MinLength, MaxLength } from 'class-validator';
import { ConcernStatus } from '@prisma/client';

export class UpdateConcernDto {
  @ApiProperty({ required: false })
  @IsString()
  @IsOptional()
  @MinLength(10)
  @MaxLength(2000)
  text?: string;

  @ApiProperty({ enum: ConcernStatus, required: false })
  @IsEnum(ConcernStatus)
  @IsOptional()
  status?: ConcernStatus;
}

