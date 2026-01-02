import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { PrismaModule } from '../prisma/prisma.module';
import { BillingModule } from '../billing/billing.module';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
import { AdminGuard } from './guards/admin.guard';
import { AdminLearnController } from './admin-learn.controller';
import { AdminLearnService } from './admin-learn.service';
import { AdminMetricsController } from './admin-metrics.controller';
import { AdminAuthController } from './admin-auth.controller';

/**
 * Admin Module
 * 
 * Provides admin dashboard endpoints for:
 * - Active clients management
 * - Payment history
 * - Refund processing
 * - Dashboard statistics
 * - Learn CMS (articles management)
 * - Analytics metrics
 * 
 * Authentication:
 * - JWT token from /admin/auth/login
 */
@Module({
  imports: [
    ConfigModule,
    JwtModule.register({}),
    PrismaModule,
    BillingModule,
  ],
  controllers: [
    AdminController,
    AdminAuthController,
    AdminLearnController,
    AdminMetricsController,
  ],
  providers: [AdminService, AdminGuard, AdminLearnService],
  exports: [AdminService],
})
export class AdminModule {}

