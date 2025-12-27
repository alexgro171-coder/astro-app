import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { User, Language } from '@prisma/client';
import * as admin from 'firebase-admin';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);
  private firebaseInitialized = false;

  constructor(
    private configService: ConfigService,
    private prisma: PrismaService,
  ) {
    this.initializeFirebase();
  }

  private initializeFirebase() {
    const projectId = this.configService.get<string>('FIREBASE_PROJECT_ID');
    const privateKeyBase64 = this.configService.get<string>('FIREBASE_PRIVATE_KEY_BASE64');
    const clientEmail = this.configService.get<string>('FIREBASE_CLIENT_EMAIL');

    if (!projectId || !privateKeyBase64 || !clientEmail) {
      this.logger.warn('Firebase not configured. Push notifications disabled.');
      return;
    }

    try {
      // Decode private key from Base64
      const privateKey = Buffer.from(privateKeyBase64, 'base64').toString('utf-8');
      
      // Check if Firebase is already initialized
      if (admin.apps.length === 0) {
        admin.initializeApp({
          credential: admin.credential.cert({
            projectId,
            privateKey,
            clientEmail,
          }),
        });
      }
      
      this.firebaseInitialized = true;
      this.logger.log('Firebase initialized successfully');
    } catch (error) {
      this.logger.error('Failed to initialize Firebase:', error.message);
    }
  }

  /**
   * Send notification when daily guidance is ready
   */
  async sendGuidanceReadyNotification(user: User): Promise<void> {
    if (!this.firebaseInitialized) {
      this.logger.debug('Firebase not initialized, skipping notification');
      return;
    }

    if (!user.notifyEnabled) {
      return;
    }

    // Get user's active devices
    const devices = await this.prisma.userDevice.findMany({
      where: {
        userId: user.id,
        isActive: true,
      },
    });

    if (devices.length === 0) {
      return;
    }

    const title = user.language === Language.RO 
      ? 'Ghidarea ta zilnică este gata!' 
      : 'Your daily guidance is ready!';
    
    const body = user.language === Language.RO
      ? 'Descoperă ce îți rezervă astrele pentru ziua de azi.'
      : 'Discover what the stars have in store for you today.';

    for (const device of devices) {
      try {
        await this.sendPushNotification(device.deviceToken, {
          title,
          body,
          data: {
            type: 'DAILY_GUIDANCE',
            screen: 'guidance',
          },
        });
      } catch (error) {
        this.logger.error(`Failed to send notification to device ${device.id}:`, error.message);
        
        // Mark device as inactive if token is invalid
        if (this.isInvalidTokenError(error)) {
          await this.prisma.userDevice.update({
            where: { id: device.id },
            data: { isActive: false },
          });
        }
      }
    }
  }

  /**
   * Send a push notification via Firebase Cloud Messaging
   */
  private async sendPushNotification(
    token: string,
    notification: {
      title: string;
      body: string;
      data?: Record<string, string>;
    },
  ): Promise<void> {
    if (!this.firebaseInitialized) {
      this.logger.debug('Firebase not initialized, mock sending notification');
      this.logger.debug(`Would send to ${token}: ${notification.title}`);
      return;
    }

    const message: admin.messaging.Message = {
      token,
      notification: {
        title: notification.title,
        body: notification.body,
      },
      data: notification.data,
      android: {
        priority: 'high',
        notification: {
          sound: 'default',
          channelId: 'daily_guidance',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    const response = await admin.messaging().send(message);
    this.logger.debug(`Notification sent successfully: ${response}`);
  }

  /**
   * Check if error is due to invalid token
   */
  private isInvalidTokenError(error: any): boolean {
    const invalidTokenCodes = [
      'messaging/invalid-registration-token',
      'messaging/registration-token-not-registered',
    ];
    return invalidTokenCodes.includes(error?.code);
  }

  /**
   * Send custom notification to a user
   */
  async sendCustomNotification(
    userId: string,
    title: string,
    body: string,
    data?: Record<string, string>,
  ): Promise<void> {
    const devices = await this.prisma.userDevice.findMany({
      where: {
        userId,
        isActive: true,
      },
    });

    for (const device of devices) {
      await this.sendPushNotification(device.deviceToken, { title, body, data });
    }
  }

  /**
   * Send notification to multiple users
   */
  async sendBulkNotification(
    userIds: string[],
    title: string,
    body: string,
    data?: Record<string, string>,
  ): Promise<{ success: number; failed: number }> {
    let success = 0;
    let failed = 0;

    for (const userId of userIds) {
      try {
        await this.sendCustomNotification(userId, title, body, data);
        success++;
      } catch (error) {
        this.logger.error(`Failed to send notification to user ${userId}:`, error.message);
        failed++;
      }
    }

    return { success, failed };
  }
}
