import { Injectable, NotFoundException, BadRequestException, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AstrologyService } from '../astrology/astrology.service';
import { EmailService } from '../email/email.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { BirthDataDto } from './dto/birth-data.dto';
import { User } from '@prisma/client';

@Injectable()
export class UsersService {
  private readonly logger = new Logger(UsersService.name);

  constructor(
    private prisma: PrismaService,
    private astrologyService: AstrologyService,
    private emailService: EmailService,
  ) {}

  async getProfile(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: {
        natalChart: {
          select: {
            sunSign: true,
            moonSign: true,
            ascendant: true,
            createdAt: true,
          },
        },
      },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    const { hashedPassword, ...profile } = user;
    return {
      ...profile,
      hasNatalChart: !!user.natalChart,
    };
  }

  async updateProfile(userId: string, updateDto: UpdateProfileDto) {
    const user = await this.prisma.user.update({
      where: { id: userId },
      data: updateDto,
    });

    const { hashedPassword, ...profile } = user;
    return profile;
  }

  async setBirthData(userId: string, birthDataDto: BirthDataDto) {
    const { birthDate, birthTime, placeName, location } = birthDataDto;

    let birthPlace: string;
    let birthLat: number;
    let birthLon: number;
    let birthTimezone: number;

    // Check if we have pre-resolved location data (from autocomplete)
    if (location) {
      // Use the pre-selected location - no ambiguity!
      birthPlace = location.adminName 
        ? `${location.placeName}, ${location.adminName}, ${location.countryName}`
        : `${location.placeName}, ${location.countryName}`;
      birthLat = location.latitude;
      birthLon = location.longitude;
      
      // Get timezone from country code
      birthTimezone = await this.astrologyService.getTimezone(location.countryCode);
      
      this.logger.log(`Using pre-selected location: ${birthPlace} (${birthLat}, ${birthLon})`);
    } else if (placeName) {
      // Legacy fallback: lookup by place name (may be ambiguous)
      this.logger.warn(`Using legacy placeName lookup for: ${placeName}`);
      
      const geoDetails = await this.astrologyService.getGeoDetails(placeName);
      
      if (!geoDetails || geoDetails.length === 0) {
        throw new BadRequestException('Could not find location. Please try a different place name.');
      }

      const geoLocation = geoDetails[0];
      birthPlace = geoLocation.displayName || placeName;
      birthLat = geoLocation.latitude;
      birthLon = geoLocation.longitude;
      birthTimezone = await this.astrologyService.getTimezone(geoLocation.countryCode);
    } else {
      throw new BadRequestException('Please provide a birth location.');
    }

    // Update user with birth data
    const user = await this.prisma.user.update({
      where: { id: userId },
      data: {
        birthDate: new Date(birthDate),
        birthTime: birthTime || 'unknown',
        birthPlace,
        birthLat,
        birthLon,
        birthTimezone,
      },
    });

    // Generate natal chart
    const natalChart = await this.astrologyService.generateNatalChart(user);

    // Mark onboarding as complete
    await this.prisma.user.update({
      where: { id: userId },
      data: { onboardingComplete: true },
    });

    return {
      message: 'Birth data saved successfully',
      sunSign: natalChart.sunSign,
      moonSign: natalChart.moonSign,
      ascendant: natalChart.ascendant,
    };
  }

  async deleteAccount(userId: string, email?: string, userName?: string) {
    this.logger.warn(`Account deletion requested for user ${userId} (${email || 'unknown email'})`);
    
    // Fetch user info before deletion for email
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { email: true, name: true },
    });

    const userEmail = email || user?.email;
    const name = userName || user?.name;

    // All related data will be cascade deleted due to Prisma schema relations
    // This includes: refreshTokens, devices, natalChart, concerns, dailyGuidances, etc.
    await this.prisma.user.delete({
      where: { id: userId },
    });

    this.logger.warn(`Account successfully deleted: user ${userId} (${userEmail || 'unknown email'})`);

    // Send confirmation email after successful deletion (don't block on failure)
    if (userEmail) {
      this.emailService.sendAccountDeletedEmail(userEmail, name || undefined).catch((err) => {
        this.logger.warn(`Failed to send account deletion email to ${userEmail}: ${err.message}`);
      });
    }

    return { 
      message: 'Account deleted successfully. All your data has been permanently removed.',
    };
  }

  /**
   * Register device with timezone and FCM token
   * This is the new comprehensive device registration endpoint
   */
  async registerDeviceV2(
    userId: string,
    data: {
      deviceId: string;
      platform: 'IOS' | 'ANDROID';
      timezoneIana?: string;
      utcOffsetMinutes?: number;
      fcmToken?: string;
      deviceToken?: string; // Legacy field
    },
  ) {
    const { deviceId, platform, timezoneIana, utcOffsetMinutes, fcmToken, deviceToken } = data;

    // If FCM token provided and it's already in use by another record, clear it first
    if (fcmToken) {
      await this.prisma.userDevice.updateMany({
        where: {
          fcmToken,
          NOT: {
            userId,
            deviceId,
          },
        },
        data: {
          fcmToken: null,
        },
      });
    }

    // Upsert device record
    const device = await this.prisma.userDevice.upsert({
      where: {
        userId_deviceId: {
          userId,
          deviceId,
        },
      },
      update: {
        platform,
        timezoneIana: timezoneIana || undefined,
        utcOffsetMinutes: utcOffsetMinutes ?? undefined,
        fcmToken: fcmToken?.trim() || undefined,
        deviceToken: deviceToken || undefined,
        isActive: true,
        lastSeenAt: new Date(),
      },
      create: {
        userId,
        deviceId,
        platform,
        timezoneIana,
        utcOffsetMinutes,
        fcmToken: fcmToken?.trim(),
        deviceToken,
        lastSeenAt: new Date(),
      },
    });

    // Update user's timezone if not already set or device is most recent
    if (timezoneIana) {
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
        select: { timezoneIana: true },
      });

      // Set user's IANA timezone if it's null (first device registered)
      if (!user?.timezoneIana) {
        await this.prisma.user.update({
          where: { id: userId },
          data: { timezoneIana },
        });
        this.logger.log(`Updated user ${userId} timezoneIana to ${timezoneIana}`);
      }
    }

    // Update user's lastActiveAt
    await this.prisma.user.update({
      where: { id: userId },
      data: { lastActiveAt: new Date() },
    });

    this.logger.log(`Device registered for user ${userId}: ${deviceId} (${platform}), tz=${timezoneIana}`);

    return {
      message: 'Device registered successfully',
      deviceId: device.id,
      timezoneIana: device.timezoneIana,
    };
  }

  /**
   * Legacy device registration (backward compatibility)
   * @deprecated Use registerDeviceV2 instead
   */
  async registerDevice(userId: string, deviceToken: string, platform: 'IOS' | 'ANDROID') {
    // Generate a device ID from the token for legacy compatibility
    const deviceId = `legacy-${deviceToken.substring(0, 32)}`;

    return this.registerDeviceV2(userId, {
      deviceId,
      platform,
      deviceToken,
      fcmToken: deviceToken, // Assume the token is also the FCM token
    });
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { email: email.toLowerCase() },
    });
  }

  async findById(id: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { id },
    });
  }
}

