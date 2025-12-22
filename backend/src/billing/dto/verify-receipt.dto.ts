import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty, IsEnum, IsOptional } from 'class-validator';

export class VerifyAppleReceiptDto {
  @ApiProperty({
    description: 'Base64 encoded receipt data from StoreKit',
    example: 'MIIbngYJKoZIhvcNAQcCoIIbj...',
  })
  @IsString()
  @IsNotEmpty()
  receiptData: string;

  @ApiProperty({
    description: 'Product ID being purchased',
    example: 'com.innerwidsom.premium.monthly',
  })
  @IsString()
  @IsNotEmpty()
  productId: string;

  @ApiProperty({
    description: 'Whether this is a sandbox transaction',
    required: false,
    default: false,
  })
  @IsOptional()
  sandbox?: boolean;
}

export class VerifyGoogleReceiptDto {
  @ApiProperty({
    description: 'Purchase token from Google Play',
    example: 'opaque-token-string',
  })
  @IsString()
  @IsNotEmpty()
  purchaseToken: string;

  @ApiProperty({
    description: 'Product ID (SKU) being purchased',
    example: 'premium_monthly',
  })
  @IsString()
  @IsNotEmpty()
  productId: string;

  @ApiProperty({
    description: 'Package name of the app',
    example: 'com.innerwidsom.app',
  })
  @IsString()
  @IsNotEmpty()
  packageName: string;
}

export class RestorePurchasesDto {
  @ApiProperty({
    description: 'Platform making the restore request',
    enum: ['ios', 'android'],
  })
  @IsEnum(['ios', 'android'])
  platform: 'ios' | 'android';

  @ApiProperty({
    description: 'Receipt data (Apple) or purchase tokens (Google)',
  })
  @IsNotEmpty()
  receipts: string | string[];
}

