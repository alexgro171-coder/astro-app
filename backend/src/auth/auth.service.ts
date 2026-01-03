import {
  Injectable,
  UnauthorizedException,
  ConflictException,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';
import { AnalyticsService } from '../analytics/analytics.service';
import { SignupDto } from './dto/signup.dto';
import { LoginDto } from './dto/login.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
    private analytics: AnalyticsService,
  ) {}

  async signup(signupDto: SignupDto) {
    const { email, password, name, language } = signupDto;

    // Check if user exists
    const existingUser = await this.prisma.user.findUnique({
      where: { email: email.toLowerCase() },
    });

    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 12);

    // Create user
    const user = await this.prisma.user.create({
      data: {
        email: email.toLowerCase(),
        hashedPassword,
        name,
        language: language || 'EN',
      },
    });

    // Log analytics event
    await this.analytics.logEvent('USER_SIGNUP', user.id, {
      provider: 'email',
      language: language || 'EN',
    });

    // Generate tokens
    const tokens = await this.generateTokens(user.id);

    return {
      user: this.sanitizeUser(user),
      ...tokens,
    };
  }

  async login(loginDto: LoginDto) {
    const { email, password } = loginDto;

    // Find user
    const user = await this.prisma.user.findUnique({
      where: { email: email.toLowerCase() },
    });

    if (!user || !user.hashedPassword) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // Verify password
    const isPasswordValid = await bcrypt.compare(password, user.hashedPassword);

    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // Generate tokens
    const tokens = await this.generateTokens(user.id);

    return {
      user: this.sanitizeUser(user),
      ...tokens,
    };
  }

  async refreshToken(refreshToken: string) {
    try {
      // Verify refresh token
      const payload = this.jwtService.verify(refreshToken, {
        secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
      });

      // Check if token exists in database
      const storedToken = await this.prisma.refreshToken.findUnique({
        where: { token: refreshToken },
        include: { user: true },
      });

      if (!storedToken || storedToken.expiresAt < new Date()) {
        throw new UnauthorizedException('Invalid refresh token');
      }

      // Delete old refresh token
      await this.prisma.refreshToken.delete({
        where: { id: storedToken.id },
      });

      // Generate new tokens
      const tokens = await this.generateTokens(payload.sub);

      return tokens;
    } catch (error) {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  async logout(userId: string, refreshToken?: string) {
    if (refreshToken) {
      // Delete specific refresh token
      await this.prisma.refreshToken.deleteMany({
        where: { token: refreshToken },
      });
    } else {
      // Delete all refresh tokens for user
      await this.prisma.refreshToken.deleteMany({
        where: { userId },
      });
    }

    return { message: 'Logged out successfully' };
  }

  private async generateTokens(userId: string) {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(
        { sub: userId },
        {
          secret: this.configService.get<string>('JWT_SECRET'),
          expiresIn: this.configService.get<string>('JWT_EXPIRES_IN', '7d'),
        },
      ),
      this.jwtService.signAsync(
        { sub: userId },
        {
          secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
          expiresIn: this.configService.get<string>('JWT_REFRESH_EXPIRES_IN', '30d'),
        },
      ),
    ]);

    // Store refresh token
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 30);

    await this.prisma.refreshToken.create({
      data: {
        token: refreshToken,
        userId,
        expiresAt,
      },
    });

    return {
      accessToken,
      refreshToken,
    };
  }

  private sanitizeUser(user: any) {
    const { hashedPassword, ...sanitized } = user;
    return sanitized;
  }

  /**
   * Request password reset - sends OTP to email
   */
  async forgotPassword(dto: ForgotPasswordDto) {
    const { email } = dto;
    this.logger.log(`Password reset requested for: ${email}`);

    // Find user
    const user = await this.prisma.user.findUnique({
      where: { email: email.toLowerCase() },
    });

    // Always return success to prevent email enumeration
    if (!user) {
      this.logger.warn(`Password reset requested for non-existent email: ${email}`);
      return { message: 'If an account exists, a reset code will be sent' };
    }

    // Delete any existing tokens for this email
    await this.prisma.passwordResetToken.deleteMany({
      where: { email: email.toLowerCase() },
    });

    // Generate 6-digit OTP
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    
    // Token expires in 15 minutes
    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + 15);

    // Create reset token
    await this.prisma.passwordResetToken.create({
      data: {
        email: email.toLowerCase(),
        code,
        expiresAt,
      },
    });

    // TODO: Send email with OTP code
    // For now, log it (in production, use email service)
    this.logger.log(`Password reset OTP for ${email}: ${code}`);

    // In development, include the code in response
    const isDev = this.configService.get<string>('NODE_ENV') !== 'production';
    
    return {
      message: 'If an account exists, a reset code will be sent',
      ...(isDev && { devCode: code }), // Only in dev mode
    };
  }

  /**
   * Reset password with OTP code
   */
  async resetPassword(dto: ResetPasswordDto) {
    const { email, code, newPassword } = dto;
    this.logger.log(`Password reset attempt for: ${email}`);

    // Find the reset token
    const resetToken = await this.prisma.passwordResetToken.findFirst({
      where: {
        email: email.toLowerCase(),
        code,
        usedAt: null,
      },
    });

    if (!resetToken) {
      this.logger.warn(`Invalid reset code for ${email}`);
      throw new BadRequestException('Invalid or expired reset code');
    }

    // Check if expired
    if (resetToken.expiresAt < new Date()) {
      this.logger.warn(`Expired reset code for ${email}`);
      throw new BadRequestException('Reset code has expired');
    }

    // Check max attempts
    if (resetToken.attempts >= 5) {
      this.logger.warn(`Max reset attempts reached for ${email}`);
      throw new BadRequestException('Maximum attempts exceeded. Please request a new code.');
    }

    // Increment attempts
    await this.prisma.passwordResetToken.update({
      where: { id: resetToken.id },
      data: { attempts: resetToken.attempts + 1 },
    });

    // Find user
    const user = await this.prisma.user.findUnique({
      where: { email: email.toLowerCase() },
    });

    if (!user) {
      throw new BadRequestException('User not found');
    }

    // Hash new password
    const hashedPassword = await bcrypt.hash(newPassword, 12);

    // Update user password
    await this.prisma.user.update({
      where: { id: user.id },
      data: { hashedPassword },
    });

    // Mark token as used
    await this.prisma.passwordResetToken.update({
      where: { id: resetToken.id },
      data: { usedAt: new Date() },
    });

    // Invalidate all refresh tokens (force re-login on all devices)
    await this.prisma.refreshToken.deleteMany({
      where: { userId: user.id },
    });

    this.logger.log(`Password reset successful for ${email}`);

    return { message: 'Password reset successful. Please login with your new password.' };
  }
}

