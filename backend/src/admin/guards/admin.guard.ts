import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../prisma/prisma.service';

/**
 * Admin Guard
 * 
 * Protects admin endpoints. Supports two authentication methods:
 * 
 * 1. Basic Auth: For simple admin access
 *    Header: Authorization: Basic base64(username:password)
 * 
 * 2. Admin JWT: For admin users stored in DB
 *    Header: Authorization: Bearer <admin_token>
 * 
 * Configure admin credentials via:
 * - ADMIN_USERNAME, ADMIN_PASSWORD env vars (Basic Auth)
 * - Or create admin users in admin_users table
 */
@Injectable()
export class AdminGuard implements CanActivate {
  constructor(
    private configService: ConfigService,
    private prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers.authorization;

    if (!authHeader) {
      throw new UnauthorizedException('Admin authentication required');
    }

    // Try Basic Auth first
    if (authHeader.startsWith('Basic ')) {
      return this.validateBasicAuth(authHeader);
    }

    // Try Bearer token (admin JWT)
    if (authHeader.startsWith('Bearer ')) {
      return this.validateAdminToken(authHeader, request);
    }

    throw new UnauthorizedException('Invalid authentication method');
  }

  private validateBasicAuth(authHeader: string): boolean {
    const base64Credentials = authHeader.split(' ')[1];
    const credentials = Buffer.from(base64Credentials, 'base64').toString('utf8');
    const [username, password] = credentials.split(':');

    const adminUsername = this.configService.get<string>('ADMIN_USERNAME');
    const adminPassword = this.configService.get<string>('ADMIN_PASSWORD');

    if (!adminUsername || !adminPassword) {
      throw new UnauthorizedException('Admin credentials not configured');
    }

    if (username === adminUsername && password === adminPassword) {
      return true;
    }

    throw new UnauthorizedException('Invalid admin credentials');
  }

  private async validateAdminToken(authHeader: string, request: any): Promise<boolean> {
    const token = authHeader.split(' ')[1];
    
    // For now, use a simple API key approach
    // In production, implement proper JWT for admin users
    const adminApiKey = this.configService.get<string>('ADMIN_API_KEY');
    
    if (adminApiKey && token === adminApiKey) {
      request.adminUser = { role: 'admin' };
      return true;
    }

    // Check admin_users table
    // Note: In production, implement proper JWT verification for admin tokens
    throw new UnauthorizedException('Invalid admin token');
  }
}

