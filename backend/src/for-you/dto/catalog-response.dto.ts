import { OneTimeServiceType } from '@prisma/client';
import { ApiProperty } from '@nestjs/swagger';

export class ServiceCatalogItemDto {
  @ApiProperty({ enum: OneTimeServiceType })
  serviceType: OneTimeServiceType;

  @ApiProperty()
  title: string;

  @ApiProperty()
  description: string;

  @ApiProperty({ description: 'Price in USD cents' })
  priceUsd: number;

  @ApiProperty()
  requiresPartner: boolean;

  @ApiProperty()
  requiresDate: boolean;

  @ApiProperty()
  isUnlocked: boolean;
}

export class CatalogResponseDto {
  @ApiProperty({ description: 'Whether beta free mode is enabled' })
  betaFree: boolean;

  @ApiProperty({ type: [ServiceCatalogItemDto] })
  services: ServiceCatalogItemDto[];
}

export class ReportMetaDto {
  @ApiProperty()
  localeUsed: string;

  @ApiProperty()
  inputHash: string;

  @ApiProperty({ enum: OneTimeServiceType })
  serviceType: OneTimeServiceType;
}

export class ReportResponseDto {
  @ApiProperty({ enum: ['NONE', 'PENDING', 'READY', 'FAILED'] })
  status: 'NONE' | 'PENDING' | 'READY' | 'FAILED';

  @ApiProperty({ required: false })
  content?: string;

  @ApiProperty({ required: false })
  errorMsg?: string;

  @ApiProperty({ type: ReportMetaDto })
  meta: ReportMetaDto;
}

