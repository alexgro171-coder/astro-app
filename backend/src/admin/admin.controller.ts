import {
  Controller,
  Get,
  Post,
  Param,
  Query,
  Body,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiBasicAuth } from '@nestjs/swagger';
import { AdminGuard } from './guards/admin.guard';
import { AdminService } from './admin.service';
import { ProcessStripeRefundDto, UpdateRefundStatusDto } from '../billing/dto/refund.dto';

/**
 * Admin Controller
 * 
 * Protected endpoints for admin dashboard.
 * Requires admin authentication (Basic Auth or Admin API Key).
 * 
 * Access: /api/v1/admin/*
 */
@ApiTags('admin')
@Controller('admin')
@UseGuards(AdminGuard)
@ApiBasicAuth()
export class AdminController {
  constructor(private adminService: AdminService) {}

  // ==================== DASHBOARD ====================

  /**
   * Get dashboard statistics
   */
  @Get('dashboard')
  @ApiOperation({ summary: 'Get dashboard overview statistics' })
  async getDashboard() {
    return this.adminService.getDashboardStats();
  }

  // ==================== CLIENTS ====================

  /**
   * Get active clients list
   */
  @Get('clients/active')
  @ApiOperation({ summary: 'Get list of active subscribers' })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'status', required: false, enum: ['trial', 'active', 'canceled', 'expired', 'past_due'] })
  @ApiQuery({ name: 'tier', required: false, enum: ['standard', 'premium'] })
  @ApiQuery({ name: 'provider', required: false, enum: ['stripe', 'apple', 'google'] })
  async getActiveClients(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('status') status?: string,
    @Query('tier') tier?: string,
    @Query('provider') provider?: string,
  ) {
    return this.adminService.getActiveClients({
      page: page ? parseInt(page) : undefined,
      limit: limit ? parseInt(limit) : undefined,
      status,
      tier,
      provider,
    });
  }

  /**
   * Get user details
   */
  @Get('clients/:userId')
  @ApiOperation({ summary: 'Get detailed user information' })
  async getUserDetails(@Param('userId') userId: string) {
    return this.adminService.getUserDetails(userId);
  }

  // ==================== PAYMENTS ====================

  /**
   * Get payments history
   */
  @Get('payments')
  @ApiOperation({ summary: 'Get payment history' })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'userId', required: false })
  @ApiQuery({ name: 'status', required: false, enum: ['pending', 'completed', 'failed', 'refunded'] })
  @ApiQuery({ name: 'provider', required: false, enum: ['stripe', 'apple', 'google'] })
  @ApiQuery({ name: 'startDate', required: false, type: String, description: 'ISO date string' })
  @ApiQuery({ name: 'endDate', required: false, type: String, description: 'ISO date string' })
  async getPayments(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('userId') userId?: string,
    @Query('status') status?: string,
    @Query('provider') provider?: string,
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
  ) {
    return this.adminService.getPayments({
      page: page ? parseInt(page) : undefined,
      limit: limit ? parseInt(limit) : undefined,
      userId,
      status,
      provider,
      startDate: startDate ? new Date(startDate) : undefined,
      endDate: endDate ? new Date(endDate) : undefined,
    });
  }

  // ==================== REFUNDS ====================

  /**
   * Get refund requests
   */
  @Get('refunds')
  @ApiOperation({ summary: 'Get refund requests' })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'status', required: false, enum: ['requested', 'approved', 'rejected', 'processed', 'failed'] })
  @ApiQuery({ name: 'provider', required: false, enum: ['stripe', 'apple', 'google'] })
  async getRefunds(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('status') status?: string,
    @Query('provider') provider?: string,
  ) {
    return this.adminService.getRefunds({
      page: page ? parseInt(page) : undefined,
      limit: limit ? parseInt(limit) : undefined,
      status,
      provider,
    });
  }

  /**
   * Process Stripe refund
   */
  @Post('refunds/stripe/process')
  @ApiOperation({ summary: 'Process a Stripe refund' })
  async processStripeRefund(@Body() dto: ProcessStripeRefundDto) {
    return this.adminService.processStripeRefund(
      dto.refundId,
      dto.amount,
      dto.adminNotes,
    );
  }

  /**
   * Update refund status (for IAP refunds)
   */
  @Post('refunds/:id/status')
  @ApiOperation({ summary: 'Update refund status (for IAP refunds)' })
  async updateRefundStatus(
    @Param('id') id: string,
    @Body() dto: UpdateRefundStatusDto,
  ) {
    return this.adminService.updateRefundStatus(
      id,
      dto.status,
      dto.adminNotes,
      dto.externalRefundId,
    );
  }

  // ==================== AUDIT ====================

  /**
   * Get audit logs
   */
  @Get('audit')
  @ApiOperation({ summary: 'Get audit logs' })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'action', required: false })
  @ApiQuery({ name: 'resourceType', required: false })
  async getAuditLogs(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('action') action?: string,
    @Query('resourceType') resourceType?: string,
  ) {
    // Implement if audit logging is needed
    return { message: 'Audit logs endpoint' };
  }
}

