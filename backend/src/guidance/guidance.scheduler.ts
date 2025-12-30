import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from '../prisma/prisma.service';
import { NotificationsService } from '../notifications/notifications.service';
import { Language } from '@prisma/client';

// Re-engagement settings
const INACTIVE_THRESHOLD_HOURS = 48;
const REENGAGEMENT_WINDOW_START_HOUR = 11;
const REENGAGEMENT_WINDOW_START_MINUTE = 48;
const REENGAGEMENT_WINDOW_END_MINUTE = 52;
const BATCH_SIZE = 500;

@Injectable()
export class GuidanceScheduler {
  private readonly logger = new Logger(GuidanceScheduler.name);

  constructor(
    private prisma: PrismaService,
    private notificationsService: NotificationsService,
  ) {}

  /**
   * Re-engagement push notifications for inactive users
   * 
   * Runs every 5 minutes and checks:
   * - Users inactive for >= 48 hours
   * - Users with valid IANA timezone
   * - Users not recently sent re-engagement push
   * - Current local time is around 11:50 AM
   * 
   * Sends FCM push to bring them back.
   */
  @Cron('*/5 * * * *') // Every 5 minutes
  async sendReengagementPushNotifications() {
    const now = new Date();
    const inactiveThreshold = new Date(now.getTime() - INACTIVE_THRESHOLD_HOURS * 60 * 60 * 1000);

    this.logger.debug('Checking for inactive users to re-engage...');

    let processedCount = 0;
    let sentCount = 0;

    try {
      // Paginated processing
      let skip = 0;

      while (true) {
        // Find eligible users in batches
        const eligibleUsers = await this.prisma.user.findMany({
          where: {
            isActive: true,
            onboardingComplete: true,
            notifyEnabled: true,
            lastActiveAt: { lt: inactiveThreshold },
            timezoneIana: { not: null },
            OR: [
              { lastReengagementPushAt: null },
              { lastReengagementPushAt: { lt: inactiveThreshold } },
            ],
          },
          include: {
            devices: {
              where: {
                isActive: true,
                fcmToken: { not: null },
              },
              select: { fcmToken: true },
            },
          },
          skip,
          take: BATCH_SIZE,
        });

        if (eligibleUsers.length === 0) {
          break;
        }

        for (const user of eligibleUsers) {
          processedCount++;

          // Check if user has any device with FCM token
          if (user.devices.length === 0) {
            continue;
          }

          // Check if current time in user's timezone is around 11:50 AM
          const userLocalTime = this.getUserLocalTime(user.timezoneIana!);
          if (!this.isWithinReengagementWindow(userLocalTime)) {
            continue;
          }

          // Send re-engagement push
          try {
            const tokens = user.devices
              .map((d) => d.fcmToken)
              .filter((t): t is string => !!t);

            if (tokens.length > 0) {
              await this.notificationsService.sendReengagementPush(
                user.id,
                tokens,
                user.language,
              );

              // Update lastReengagementPushAt
              await this.prisma.user.update({
                where: { id: user.id },
                data: { lastReengagementPushAt: now },
              });

              sentCount++;
              this.logger.debug(
                `Sent re-engagement push to user ${user.id} (tz: ${user.timezoneIana}, local: ${userLocalTime.toISOString()})`,
              );
            }
          } catch (error) {
            this.logger.error(`Failed to send re-engagement to user ${user.id}: ${error.message}`);
          }
        }

        skip += BATCH_SIZE;

        // Stop if we processed less than batch size (no more users)
        if (eligibleUsers.length < BATCH_SIZE) {
          break;
        }
      }

      if (sentCount > 0) {
        this.logger.log(
          `Re-engagement check complete. Processed: ${processedCount}, Sent: ${sentCount}`,
        );
      }
    } catch (error) {
      this.logger.error(`Re-engagement cron failed: ${error.message}`);
    }
  }

  /**
   * Get current time in user's timezone
   */
  private getUserLocalTime(timezoneIana: string): Date {
    try {
      const now = new Date();
      const options: Intl.DateTimeFormatOptions = {
        timeZone: timezoneIana,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        hour12: false,
      };

      // Get formatted parts
      const formatter = new Intl.DateTimeFormat('en-CA', options);
      const parts = formatter.formatToParts(now);

      const year = parseInt(parts.find((p) => p.type === 'year')?.value || '2025');
      const month = parseInt(parts.find((p) => p.type === 'month')?.value || '1') - 1;
      const day = parseInt(parts.find((p) => p.type === 'day')?.value || '1');
      const hour = parseInt(parts.find((p) => p.type === 'hour')?.value || '0');
      const minute = parseInt(parts.find((p) => p.type === 'minute')?.value || '0');

      return new Date(year, month, day, hour, minute);
    } catch (e) {
      this.logger.warn(`Invalid timezone ${timezoneIana}: ${e}`);
      return new Date();
    }
  }

  /**
   * Check if time is within re-engagement window (11:48 - 11:52)
   */
  private isWithinReengagementWindow(localTime: Date): boolean {
    const hour = localTime.getHours();
    const minute = localTime.getMinutes();

    return (
      hour === REENGAGEMENT_WINDOW_START_HOUR &&
      minute >= REENGAGEMENT_WINDOW_START_MINUTE &&
      minute <= REENGAGEMENT_WINDOW_END_MINUTE
    );
  }

  /**
   * Clean up old transits data (older than 7 days)
   * Runs every day at 3:00 AM UTC
   */
  @Cron('0 3 * * *')
  async cleanupOldData() {
    this.logger.log('Starting old data cleanup...');

    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    try {
      // Clean up old transits
      const deletedTransits = await this.prisma.dailyTransit.deleteMany({
        where: { createdAt: { lt: sevenDaysAgo } },
      });

      // Clean up old FAILED guidance (allow retry)
      const deletedFailed = await this.prisma.dailyGuidance.deleteMany({
        where: {
          status: 'FAILED',
          createdAt: { lt: sevenDaysAgo },
        },
      });

      this.logger.log(
        `Cleanup complete. Deleted: ${deletedTransits.count} transits, ${deletedFailed.count} failed guidances`,
      );
    } catch (error) {
      this.logger.error(`Cleanup failed: ${error.message}`);
    }
  }
}
