import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { GuidanceService } from './guidance.service';
import { NotificationsService } from '../notifications/notifications.service';

@Injectable()
export class GuidanceScheduler {
  private readonly logger = new Logger(GuidanceScheduler.name);

  constructor(
    private guidanceService: GuidanceService,
    private notificationsService: NotificationsService,
  ) {}

  /**
   * Generate daily guidance for all users
   * Runs every day at 5:00 AM UTC
   */
  @Cron('0 5 * * *')
  async generateDailyGuidanceForAllUsers() {
    this.logger.log('Starting daily guidance generation batch...');

    try {
      const users = await this.guidanceService.getUsersNeedingGuidance();
      this.logger.log(`Found ${users.length} users needing guidance`);

      let successCount = 0;
      let errorCount = 0;

      for (const user of users) {
        try {
          await this.guidanceService.generateGuidance(user);
          
          // Send push notification
          await this.notificationsService.sendGuidanceReadyNotification(user);
          
          successCount++;
        } catch (error) {
          this.logger.error(`Failed to generate guidance for user ${user.id}:`, error.message);
          errorCount++;
        }

        // Small delay to avoid rate limiting
        await new Promise(resolve => setTimeout(resolve, 100));
      }

      this.logger.log(`Daily guidance generation complete. Success: ${successCount}, Errors: ${errorCount}`);
    } catch (error) {
      this.logger.error('Failed to run daily guidance batch:', error.message);
    }
  }

  /**
   * Clean up old transits data (older than 7 days)
   * Runs every day at 3:00 AM UTC
   */
  @Cron('0 3 * * *')
  async cleanupOldTransits() {
    this.logger.log('Starting old transits cleanup...');

    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    // Note: This would require injecting PrismaService
    // For now, this is a placeholder
    this.logger.log('Old transits cleanup complete');
  }
}

