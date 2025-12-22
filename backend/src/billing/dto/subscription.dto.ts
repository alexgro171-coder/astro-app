import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsEnum, IsOptional, IsNumber } from 'class-validator';

export class SubscriptionResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ enum: ['stripe', 'apple', 'google'] })
  provider: string;

  @ApiProperty({ enum: ['standard', 'premium'] })
  tier: string;

  @ApiProperty({ enum: ['monthly', 'yearly'] })
  period: string;

  @ApiProperty({ enum: ['trial', 'active', 'canceled', 'expired', 'past_due'] })
  status: string;

  @ApiProperty()
  startAt: Date;

  @ApiProperty({ required: false })
  trialEndAt?: Date;

  @ApiProperty({ required: false })
  currentPeriodEndAt?: Date;

  @ApiProperty({ required: false })
  canceledAt?: Date;
}

export class CreateStripeCheckoutDto {
  @ApiProperty({
    description: 'Price ID from Stripe',
    example: 'price_premium_monthly',
  })
  @IsString()
  priceId: string;

  @ApiProperty({
    description: 'Success URL after payment',
    example: 'https://app.innerwidsom.com/success',
  })
  @IsString()
  successUrl: string;

  @ApiProperty({
    description: 'Cancel URL if user cancels',
    example: 'https://app.innerwidsom.com/cancel',
  })
  @IsString()
  cancelUrl: string;
}

export class UpdateSubscriptionDto {
  @ApiProperty({
    description: 'New tier to upgrade/downgrade to',
    enum: ['standard', 'premium'],
    required: false,
  })
  @IsOptional()
  @IsEnum(['standard', 'premium'])
  tier?: 'standard' | 'premium';

  @ApiProperty({
    description: 'New billing period',
    enum: ['monthly', 'yearly'],
    required: false,
  })
  @IsOptional()
  @IsEnum(['monthly', 'yearly'])
  period?: 'monthly' | 'yearly';
}

export class CancelSubscriptionDto {
  @ApiProperty({
    description: 'Reason for cancellation',
    required: false,
  })
  @IsOptional()
  @IsString()
  reason?: string;

  @ApiProperty({
    description: 'Cancel immediately or at period end',
    default: false,
  })
  @IsOptional()
  immediate?: boolean;
}

