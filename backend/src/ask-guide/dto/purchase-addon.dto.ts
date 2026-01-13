import { IsNotEmpty, IsString, IsOptional, IsEnum } from 'class-validator';

export enum AddonPaymentProvider {
  APPLE = 'APPLE',
  GOOGLE = 'GOOGLE',
  STRIPE = 'STRIPE',
}

export class PurchaseAddonDto {
  @IsNotEmpty()
  @IsString()
  purchaseId: string; // Transaction ID from App Store / Play Store / Stripe

  @IsNotEmpty()
  @IsEnum(AddonPaymentProvider)
  provider: AddonPaymentProvider;

  @IsOptional()
  @IsString()
  receiptData?: string; // For validation purposes
}

export class AddonPurchaseResponseDto {
  success: boolean;
  message: string;
  addon?: {
    id: string;
    billingMonthEnd: string;
    newLimit: number;
  };
}

export class AddonStatusResponseDto {
  hasAddon: boolean;
  canPurchase: boolean;
  price: {
    amount: number;
    currency: string;
    display: string;
  };
  billingMonthEnd?: string;
}
