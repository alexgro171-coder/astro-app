import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsEnum, IsOptional, IsNumber, Min, Max } from 'class-validator';

export class CreateRefundRequestDto {
  @ApiProperty({
    description: 'Reason for refund request',
    example: 'Service not as expected',
  })
  @IsString()
  reason: string;

  @ApiProperty({
    description: 'Payment ID to refund (optional, defaults to last payment)',
    required: false,
  })
  @IsOptional()
  @IsString()
  paymentId?: string;
}

export class ProcessStripeRefundDto {
  @ApiProperty({
    description: 'Refund request ID',
  })
  @IsString()
  refundId: string;

  @ApiProperty({
    description: 'Amount to refund in cents (optional for full refund)',
    required: false,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  amount?: number;

  @ApiProperty({
    description: 'Admin notes',
    required: false,
  })
  @IsOptional()
  @IsString()
  adminNotes?: string;
}

export class UpdateRefundStatusDto {
  @ApiProperty({
    description: 'New status for the refund',
    enum: ['approved', 'rejected', 'processed'],
  })
  @IsEnum(['approved', 'rejected', 'processed'])
  status: 'approved' | 'rejected' | 'processed';

  @ApiProperty({
    description: 'Admin notes',
    required: false,
  })
  @IsOptional()
  @IsString()
  adminNotes?: string;

  @ApiProperty({
    description: 'External refund ID (from Stripe/Apple/Google)',
    required: false,
  })
  @IsOptional()
  @IsString()
  externalRefundId?: string;
}

export class RefundResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  userId: string;

  @ApiProperty({ enum: ['stripe', 'apple', 'google'] })
  provider: string;

  @ApiProperty({ required: false })
  amount?: number;

  @ApiProperty()
  reason: string;

  @ApiProperty({ enum: ['requested', 'approved', 'rejected', 'processed', 'failed'] })
  status: string;

  @ApiProperty({ required: false })
  adminNotes?: string;

  @ApiProperty({ required: false })
  processedAt?: Date;

  @ApiProperty()
  createdAt: Date;
}

