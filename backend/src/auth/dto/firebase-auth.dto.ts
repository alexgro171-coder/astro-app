import { IsString, IsEnum, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Language } from '@prisma/client';

export enum FirebaseAuthProvider {
  GOOGLE = 'google',
  APPLE = 'apple',
}

export class FirebaseAuthDto {
  @ApiProperty({
    description: 'Firebase ID token received from Firebase Auth SDK',
    example: 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...',
  })
  @IsString()
  idToken: string;

  @ApiProperty({
    description: 'Auth provider used',
    enum: FirebaseAuthProvider,
    example: 'google',
  })
  @IsEnum(FirebaseAuthProvider)
  provider: FirebaseAuthProvider;

  @ApiProperty({
    description: 'User display name (optional, used for new accounts)',
    required: false,
    example: 'John Doe',
  })
  @IsOptional()
  @IsString()
  name?: string;

  @ApiProperty({
    description: 'Preferred language for AI-generated content',
    enum: Language,
    required: false,
    example: 'EN',
  })
  @IsOptional()
  @IsEnum(Language)
  language?: Language;
}

