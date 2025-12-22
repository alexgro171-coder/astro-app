import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from '../prisma/prisma.module';
import { BillingModule } from '../billing/billing.module';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
import { AdminGuard } from './guards/admin.guard';

/**
 * Admin Module
 * 
 * Provides admin dashboard endpoints for:
 * - Active clients management
 * - Payment history
 * - Refund processing
 * - Dashboard statistics
 * 
 * Authentication:
 * - Basic Auth: Set ADMIN_USERNAME and ADMIN_PASSWORD env vars
 * - API Key: Set ADMIN_API_KEY env var
 */
@Module({
  imports: [
    ConfigModule,
    PrismaModule,
    BillingModule,
  ],
  controllers: [AdminController],
  providers: [AdminService, AdminGuard],
  exports: [AdminService],
})
export class AdminModule {}

