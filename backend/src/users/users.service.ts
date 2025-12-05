import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AstrologyService } from '../astrology/astrology.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { BirthDataDto } from './dto/birth-data.dto';
import { User } from '@prisma/client';

@Injectable()
export class UsersService {
  constructor(
    private prisma: PrismaService,
    private astrologyService: AstrologyService,
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
    const { birthDate, birthTime, placeName } = birthDataDto;

    // Get geo details from AstrologyAPI
    const geoDetails = await this.astrologyService.getGeoDetails(placeName);
    
    if (!geoDetails || geoDetails.length === 0) {
      throw new BadRequestException('Could not find location. Please try a different place name.');
    }

    const location = geoDetails[0];

    // Get timezone
    const timezone = await this.astrologyService.getTimezone(location.country_code);

    // Update user with birth data (convert strings to numbers for Prisma)
    const user = await this.prisma.user.update({
      where: { id: userId },
      data: {
        birthDate: new Date(birthDate),
        birthTime: birthTime || 'unknown',
        birthPlace: location.place_name || placeName,
        birthLat: parseFloat(String(location.latitude)),
        birthLon: parseFloat(String(location.longitude)),
        birthTimezone: parseFloat(String(timezone)) || 0,
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

  async deleteAccount(userId: string) {
    await this.prisma.user.delete({
      where: { id: userId },
    });

    return { message: 'Account deleted successfully' };
  }

  async registerDevice(userId: string, deviceToken: string, platform: 'IOS' | 'ANDROID') {
    await this.prisma.userDevice.upsert({
      where: {
        userId_deviceToken: {
          userId,
          deviceToken,
        },
      },
      update: {
        isActive: true,
        platform,
      },
      create: {
        userId,
        deviceToken,
        platform,
      },
    });

    return { message: 'Device registered successfully' };
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

