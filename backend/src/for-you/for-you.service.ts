import {
  Injectable,
  Logger,
  BadRequestException,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  OneTimeServiceType,
  ReadingStatus,
  User,
  PurchaseStatus,
} from '@prisma/client';
import { AstrologyApiService } from './astrology-api.service';
import { TranslationService } from './translation.service';
import { GenerateReportDto } from './dto/generate-report.dto';
import {
  CatalogResponseDto,
  ReportResponseDto,
} from './dto/catalog-response.dto';
import {
  SERVICE_CATALOG,
  ServiceCatalogEntry,
  getCompatibilityServices,
  isBetaFree,
} from './service-catalog';
import { computeInputHash, InputHashData } from './utils/input-hash.util';
import { resolveLocale } from './utils/locale.util';
import { AnalyticsService } from '../analytics/analytics.service';

@Injectable()
export class ForYouService {
  private readonly logger = new Logger(ForYouService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly astrologyApi: AstrologyApiService,
    private readonly translationService: TranslationService,
    private readonly analyticsService: AnalyticsService,
  ) {}

  /**
   * Get the service catalog with unlock status for the user.
   */
  async getCatalog(userId: string): Promise<CatalogResponseDto> {
    const betaFree = isBetaFree();

    // Get user's purchases
    const purchases = await this.prisma.userPurchase.findMany({
      where: {
        userId,
        status: PurchaseStatus.COMPLETED,
      },
      select: { productKey: true },
    });
    const unlockedProducts = new Set(purchases.map((p) => p.productKey));

    // Build catalog entries with unlock status
    const services = getCompatibilityServices().map((entry) => ({
      serviceType: entry.serviceType,
      title: entry.title,
      description: entry.description,
      priceUsd: entry.priceUsd,
      requiresPartner: entry.requiresPartner,
      requiresDate: entry.requiresDate,
      isUnlocked: betaFree || unlockedProducts.has(entry.productKey),
    }));

    // Add Moon Phase separately
    const moonPhase = SERVICE_CATALOG.MOON_PHASE_REPORT;
    services.push({
      serviceType: moonPhase.serviceType,
      title: moonPhase.title,
      description: moonPhase.description,
      priceUsd: moonPhase.priceUsd,
      requiresPartner: moonPhase.requiresPartner,
      requiresDate: moonPhase.requiresDate,
      isUnlocked: betaFree || unlockedProducts.has(moonPhase.productKey),
    });

    return { betaFree, services };
  }

  /**
   * Get existing report status and content.
   */
  async getReport(
    userId: string,
    serviceType: OneTimeServiceType,
    locale: string,
    partnerHash?: string,
    date?: string,
  ): Promise<ReportResponseDto> {
    const user = await this.getUser(userId);
    const catalogEntry = SERVICE_CATALOG[serviceType];

    if (!catalogEntry) {
      throw new NotFoundException(`Unknown service type: ${serviceType}`);
    }

    // Compute input hash
    const inputHashData = this.buildInputHashData(
      serviceType,
      locale,
      user,
      undefined, // partner data not available in GET
      date,
    );
    const inputHash = partnerHash || computeInputHash(inputHashData);

    // Find existing reading
    const reading = await this.prisma.oneTimeReading.findUnique({
      where: {
        userId_serviceType_locale_inputHash: {
          userId,
          serviceType,
          locale,
          inputHash,
        },
      },
    });

    if (!reading) {
      return {
        status: 'NONE',
        meta: {
          localeUsed: locale,
          inputHash,
          serviceType,
        },
      };
    }

    // Log view event
    if (reading.status === 'READY') {
      await this.analyticsService.logEvent(
        'ONE_TIME_SERVICE_VIEWED',
        userId,
        { serviceType, locale },
      );
    }

    return {
      status: reading.status as 'PENDING' | 'READY' | 'FAILED',
      content: reading.content || undefined,
      errorMsg: reading.errorMsg || undefined,
      meta: {
        localeUsed: reading.locale,
        inputHash: reading.inputHash,
        serviceType: reading.serviceType,
      },
    };
  }

  /**
   * Generate a report (idempotent).
   */
  async generateReport(
    userId: string,
    serviceType: OneTimeServiceType,
    dto: GenerateReportDto,
    acceptLanguage?: string,
  ): Promise<ReportResponseDto> {
    const user = await this.getUser(userId);
    const catalogEntry = SERVICE_CATALOG[serviceType];

    if (!catalogEntry) {
      throw new NotFoundException(`Unknown service type: ${serviceType}`);
    }

    // Validate partner requirement
    if (catalogEntry.requiresPartner && !dto.partnerProfile) {
      throw new BadRequestException(
        `${serviceType} requires partner profile data`,
      );
    }

    // Resolve locale
    const locale = resolveLocale(
      dto.locale,
      acceptLanguage,
      user.language?.toLowerCase(),
    );

    // Compute input hash for idempotency
    const inputHashData = this.buildInputHashData(
      serviceType,
      locale,
      user,
      dto.partnerProfile,
      dto.date,
    );
    const inputHash = computeInputHash(inputHashData);

    // Check for existing reading (idempotency)
    const existingReading = await this.prisma.oneTimeReading.findUnique({
      where: {
        userId_serviceType_locale_inputHash: {
          userId,
          serviceType,
          locale,
          inputHash,
        },
      },
    });

    if (existingReading) {
      // If already READY or PENDING, return existing
      if (
        existingReading.status === 'READY' ||
        existingReading.status === 'PENDING'
      ) {
        this.logger.log(
          `Returning existing ${existingReading.status} reading for ${serviceType}`,
        );
        return {
          status: existingReading.status as 'PENDING' | 'READY',
          content: existingReading.content || undefined,
          meta: {
            localeUsed: existingReading.locale,
            inputHash: existingReading.inputHash,
            serviceType: existingReading.serviceType,
          },
        };
      }
      // If FAILED, we'll retry by updating the record
    }

    // Check gating (purchase required)
    await this.checkGating(userId, catalogEntry);

    // Log event
    await this.analyticsService.logEvent('ONE_TIME_SERVICE_OPENED', userId, {
      serviceType,
      locale,
    });

    // Create or update reading as PENDING
    const reading = await this.prisma.oneTimeReading.upsert({
      where: {
        userId_serviceType_locale_inputHash: {
          userId,
          serviceType,
          locale,
          inputHash,
        },
      },
      create: {
        userId,
        serviceType,
        locale,
        inputHash,
        status: 'PENDING',
        inputSnapshot: inputHashData as any,
      },
      update: {
        status: 'PENDING',
        errorMsg: null,
        inputSnapshot: inputHashData as any,
      },
    });

    // Generate report asynchronously (but we await for now in this simple implementation)
    try {
      // Call AstrologyAPI
      this.logger.log(`Generating ${serviceType} via AstrologyAPI...`);
      const apiResponse = await this.astrologyApi.generateReport(
        serviceType,
        {
          birthDate: user.birthDate!,
          birthTime: user.birthTime || undefined,
          birthLat: user.birthLat || undefined,
          birthLon: user.birthLon || undefined,
          birthTimezone: user.birthTimezone || undefined,
        },
        dto.partnerProfile,
        dto.date,
      );

      // Translate if needed
      this.logger.log(`Translating to ${locale}...`);
      const translatedContent = await this.translationService.translate(
        apiResponse.reportText,
        locale,
      );

      // Update reading with content
      const updatedReading = await this.prisma.oneTimeReading.update({
        where: { id: reading.id },
        data: {
          status: 'READY',
          content: translatedContent,
        },
      });

      // Log success event
      await this.analyticsService.logEvent(
        'ONE_TIME_SERVICE_GENERATED',
        userId,
        { serviceType, locale, success: true },
      );

      this.logger.log(`${serviceType} generated successfully`);

      return {
        status: 'READY',
        content: updatedReading.content || undefined,
        meta: {
          localeUsed: locale,
          inputHash,
          serviceType,
        },
      };
    } catch (error) {
      this.logger.error(
        `Failed to generate ${serviceType}: ${error.message}`,
        error.stack,
      );

      // Update reading with error
      await this.prisma.oneTimeReading.update({
        where: { id: reading.id },
        data: {
          status: 'FAILED',
          errorMsg: error.message,
        },
      });

      // Log failure event
      await this.analyticsService.logEvent(
        'ONE_TIME_SERVICE_GENERATED',
        userId,
        { serviceType, locale, success: false, error: error.message },
      );

      return {
        status: 'FAILED',
        errorMsg: error.message,
        meta: {
          localeUsed: locale,
          inputHash,
          serviceType,
        },
      };
    }
  }

  /**
   * Get user with natal data.
   */
  private async getUser(userId: string): Promise<User> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    if (!user.birthDate) {
      throw new BadRequestException(
        'Birth data required. Please complete your profile first.',
      );
    }

    return user;
  }

  /**
   * Check if user has access to the service.
   */
  private async checkGating(
    userId: string,
    catalogEntry: ServiceCatalogEntry,
  ): Promise<void> {
    // Beta mode = free access
    if (isBetaFree()) {
      this.logger.log(`Beta free mode: granting access to ${catalogEntry.serviceType}`);
      return;
    }

    // Check for purchase
    const purchase = await this.prisma.userPurchase.findUnique({
      where: {
        userId_productKey: {
          userId,
          productKey: catalogEntry.productKey,
        },
      },
    });

    if (!purchase || purchase.status !== PurchaseStatus.COMPLETED) {
      throw new ForbiddenException({
        message: 'Purchase required to access this service',
        requiresPurchase: true,
        productKey: catalogEntry.productKey,
        priceUsd: catalogEntry.priceUsd,
      });
    }
  }

  /**
   * Build input hash data structure.
   */
  private buildInputHashData(
    serviceType: OneTimeServiceType,
    locale: string,
    user: User,
    partner?: GenerateReportDto['partnerProfile'],
    date?: string,
  ): InputHashData {
    return {
      serviceType,
      locale,
      userNatal: {
        birthDate: user.birthDate!.toISOString().split('T')[0],
        birthTime: user.birthTime || undefined,
        birthLat: user.birthLat || undefined,
        birthLon: user.birthLon || undefined,
        birthTimezone: user.birthTimezone || undefined,
      },
      partner: partner || undefined,
      date: date || undefined,
    };
  }
}

