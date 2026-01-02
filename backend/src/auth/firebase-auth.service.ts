import { Injectable, Logger, UnauthorizedException, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import * as admin from 'firebase-admin';
import { Language } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { FirebaseAuthDto, FirebaseAuthProvider } from './dto/firebase-auth.dto';

@Injectable()
export class FirebaseAuthService implements OnModuleInit {
  private readonly logger = new Logger(FirebaseAuthService.name);
  private firebaseInitialized = false;

  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  onModuleInit() {
    this.initializeFirebase();
  }

  private initializeFirebase() {
    const projectId = this.configService.get<string>('FIREBASE_PROJECT_ID');
    const privateKeyBase64 = this.configService.get<string>('FIREBASE_PRIVATE_KEY_BASE64');
    const clientEmail = this.configService.get<string>('FIREBASE_CLIENT_EMAIL');

    if (!projectId || !privateKeyBase64 || !clientEmail) {
      this.logger.warn('Firebase Auth not configured. Social login disabled.');
      return;
    }

    try {
      // Check if Firebase is already initialized (by NotificationsService)
      if (admin.apps.length === 0) {
        const privateKey = Buffer.from(privateKeyBase64, 'base64').toString('utf-8');
        admin.initializeApp({
          credential: admin.credential.cert({
            projectId,
            privateKey,
            clientEmail,
          }),
        });
      }
      
      this.firebaseInitialized = true;
      this.logger.log('Firebase Auth initialized successfully');
    } catch (error) {
      this.logger.error('Failed to initialize Firebase Auth:', error.message);
    }
  }

  /**
   * Authenticate user with Firebase ID token
   */
  async authenticateWithFirebase(dto: FirebaseAuthDto) {
    if (!this.firebaseInitialized) {
      throw new UnauthorizedException('Firebase Auth not configured');
    }

    try {
      // Verify Firebase ID token
      const decodedToken = await admin.auth().verifyIdToken(dto.idToken);
      
      const { uid, email, name: firebaseName, picture } = decodedToken;

      if (!email) {
        throw new UnauthorizedException('Email is required for authentication');
      }

      // Find or create user
      let user = await this.findUserByFirebaseUid(uid, dto.provider);
      
      if (!user) {
        // Try to find by email (link existing account)
        user = await this.prisma.user.findUnique({
          where: { email: email.toLowerCase() },
        });

        if (user) {
          // Link Firebase account to existing user
          user = await this.linkFirebaseAccount(user.id, uid, dto.provider);
          this.logger.log(`Linked ${dto.provider} account to existing user ${user.id}`);
        } else {
          // Create new user
          user = await this.createUserFromFirebase(uid, email, dto.provider, dto.name || firebaseName, dto.language);
          this.logger.log(`Created new user ${user.id} via ${dto.provider}`);
        }
      }

      // Generate JWT tokens
      const tokens = await this.generateTokens(user.id);

      return {
        user: this.sanitizeUser(user),
        ...tokens,
        isNewUser: !user.onboardingComplete,
      };
    } catch (error) {
      this.logger.error(`Firebase auth failed: ${error.message}`);
      
      if (error.code === 'auth/id-token-expired') {
        throw new UnauthorizedException('Token expired. Please sign in again.');
      }
      if (error.code === 'auth/argument-error') {
        throw new UnauthorizedException('Invalid token format');
      }
      
      throw new UnauthorizedException('Authentication failed');
    }
  }

  /**
   * Find user by Firebase UID
   */
  private async findUserByFirebaseUid(uid: string, provider: FirebaseAuthProvider) {
    if (provider === FirebaseAuthProvider.GOOGLE) {
      return this.prisma.user.findUnique({
        where: { googleId: uid },
      });
    } else if (provider === FirebaseAuthProvider.APPLE) {
      return this.prisma.user.findUnique({
        where: { appleId: uid },
      });
    }
    return null;
  }

  /**
   * Link Firebase account to existing user
   */
  private async linkFirebaseAccount(userId: string, uid: string, provider: FirebaseAuthProvider) {
    const updateData: any = {};
    
    if (provider === FirebaseAuthProvider.GOOGLE) {
      updateData.googleId = uid;
    } else if (provider === FirebaseAuthProvider.APPLE) {
      updateData.appleId = uid;
    }

    return this.prisma.user.update({
      where: { id: userId },
      data: updateData,
    });
  }

  /**
   * Create new user from Firebase auth
   */
  private async createUserFromFirebase(
    uid: string,
    email: string,
    provider: FirebaseAuthProvider,
    name?: string,
    language?: Language,
  ) {
    const data: any = {
      email: email.toLowerCase(),
      emailVerified: true, // Firebase verifies email
      name: name || email.split('@')[0],
      language: language || 'EN',
    };

    if (provider === FirebaseAuthProvider.GOOGLE) {
      data.googleId = uid;
    } else if (provider === FirebaseAuthProvider.APPLE) {
      data.appleId = uid;
    }

    return this.prisma.user.create({ data });
  }

  /**
   * Generate JWT tokens
   */
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

    return { accessToken, refreshToken };
  }

  /**
   * Remove sensitive data from user object
   */
  private sanitizeUser(user: any) {
    const { hashedPassword, ...sanitized } = user;
    return sanitized;
  }
}

