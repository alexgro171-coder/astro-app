import {
  Controller,
  Post,
  Body,
  UnauthorizedException,
  Logger,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBody } from '@nestjs/swagger';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';

class AdminLoginDto {
  email: string;
  password: string;
}

@ApiTags('Admin - Auth')
@Controller('admin/auth')
export class AdminAuthController {
  private readonly logger = new Logger(AdminAuthController.name);

  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  @Post('login')
  @ApiOperation({ summary: 'Admin login' })
  @ApiBody({ type: AdminLoginDto })
  async login(@Body() body: AdminLoginDto) {
    const { email, password } = body;

    if (!email || !password) {
      throw new UnauthorizedException('Email and password required');
    }

    const admin = await this.prisma.adminUser.findUnique({
      where: { email: email.toLowerCase() },
    });

    if (!admin) {
      this.logger.warn(`Admin login failed: user not found for ${email}`);
      throw new UnauthorizedException('Invalid credentials');
    }

    if (!admin.isActive) {
      this.logger.warn(`Admin login failed: account deactivated for ${email}`);
      throw new UnauthorizedException('Account is deactivated');
    }

    const isPasswordValid = await bcrypt.compare(password, admin.hashedPassword);

    if (!isPasswordValid) {
      this.logger.warn(`Admin login failed: invalid password for ${email}`);
      throw new UnauthorizedException('Invalid credentials');
    }

    // Update last login
    await this.prisma.adminUser.update({
      where: { id: admin.id },
      data: { lastLoginAt: new Date() },
    });

    // Generate JWT
    const token = await this.jwtService.signAsync(
      { sub: admin.id, role: admin.role, isAdmin: true },
      {
        secret: this.configService.get<string>('JWT_SECRET'),
        expiresIn: '24h',
      },
    );

    this.logger.log(`Admin login successful: ${email}`);

    return {
      token,
      admin: {
        id: admin.id,
        email: admin.email,
        name: admin.name,
        role: admin.role,
      },
    };
  }
}

