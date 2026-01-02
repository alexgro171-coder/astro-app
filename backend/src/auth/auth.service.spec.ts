import { Test, TestingModule } from '@nestjs/testing';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { ConflictException, UnauthorizedException } from '@nestjs/common';
import { Language } from '@prisma/client';
import { AuthService } from './auth.service';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';

// Mock bcrypt
jest.mock('bcrypt', () => ({
  hash: jest.fn(),
  compare: jest.fn(),
}));

describe('AuthService', () => {
  let service: AuthService;
  let prismaService: PrismaService;
  let jwtService: JwtService;
  let configService: ConfigService;

  const mockPrismaService = {
    user: {
      findUnique: jest.fn(),
      create: jest.fn(),
    },
    refreshToken: {
      create: jest.fn(),
      findUnique: jest.fn(),
      delete: jest.fn(),
      deleteMany: jest.fn(),
    },
  };

  const mockJwtService = {
    signAsync: jest.fn(),
    verify: jest.fn(),
  };

  const mockConfigService = {
    get: jest.fn((key: string) => {
      const config: Record<string, string> = {
        JWT_SECRET: 'test-secret',
        JWT_REFRESH_SECRET: 'test-refresh-secret',
        JWT_EXPIRES_IN: '7d',
        JWT_REFRESH_EXPIRES_IN: '30d',
      };
      return config[key];
    }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: JwtService, useValue: mockJwtService },
        { provide: ConfigService, useValue: mockConfigService },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    prismaService = module.get<PrismaService>(PrismaService);
    jwtService = module.get<JwtService>(JwtService);
    configService = module.get<ConfigService>(ConfigService);

    // Reset mocks
    jest.clearAllMocks();
  });

  describe('signup', () => {
    const signupDto = {
      email: 'test@example.com',
      password: 'password123',
      name: 'Test User',
    };

    const mockUser = {
      id: 'user-123',
      email: 'test@example.com',
      name: 'Test User',
      language: 'EN',
      hashedPassword: 'hashedPassword',
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    beforeEach(() => {
      (bcrypt.hash as jest.Mock).mockResolvedValue('hashedPassword');
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue(mockUser);
      mockJwtService.signAsync.mockResolvedValue('mock-token');
      mockPrismaService.refreshToken.create.mockResolvedValue({});
    });

    it('should create a new user with default language EN', async () => {
      const result = await service.signup(signupDto);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: {
          email: 'test@example.com',
          hashedPassword: 'hashedPassword',
          name: 'Test User',
          language: 'EN',
        },
      });

      expect(result).toHaveProperty('user');
      expect(result).toHaveProperty('accessToken');
      expect(result).toHaveProperty('refreshToken');
      expect(result.user).not.toHaveProperty('hashedPassword');
    });

    it('should create a new user with specified language RO', async () => {
      const signupWithLang = { ...signupDto, language: Language.RO };
      const mockUserRO = { ...mockUser, language: Language.RO };
      mockPrismaService.user.create.mockResolvedValue(mockUserRO);

      const result = await service.signup(signupWithLang);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: {
          email: 'test@example.com',
          hashedPassword: 'hashedPassword',
          name: 'Test User',
          language: Language.RO,
        },
      });

      expect(result.user.language).toBe(Language.RO);
    });

    it('should create a new user with specified language FR', async () => {
      const signupWithLang = { ...signupDto, language: Language.FR };
      const mockUserFR = { ...mockUser, language: Language.FR };
      mockPrismaService.user.create.mockResolvedValue(mockUserFR);

      await service.signup(signupWithLang);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({ language: Language.FR }),
      });
    });

    it('should create a new user with specified language DE', async () => {
      const signupWithLang = { ...signupDto, language: Language.DE };
      const mockUserDE = { ...mockUser, language: Language.DE };
      mockPrismaService.user.create.mockResolvedValue(mockUserDE);

      await service.signup(signupWithLang);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({ language: Language.DE }),
      });
    });

    it('should create a new user with specified language ES', async () => {
      const signupWithLang = { ...signupDto, language: Language.ES };
      const mockUserES = { ...mockUser, language: Language.ES };
      mockPrismaService.user.create.mockResolvedValue(mockUserES);

      await service.signup(signupWithLang);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({ language: Language.ES }),
      });
    });

    it('should create a new user with specified language IT', async () => {
      const signupWithLang = { ...signupDto, language: Language.IT };
      const mockUserIT = { ...mockUser, language: Language.IT };
      mockPrismaService.user.create.mockResolvedValue(mockUserIT);

      await service.signup(signupWithLang);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({ language: Language.IT }),
      });
    });

    it('should create a new user with specified language HU', async () => {
      const signupWithLang = { ...signupDto, language: Language.HU };
      const mockUserHU = { ...mockUser, language: Language.HU };
      mockPrismaService.user.create.mockResolvedValue(mockUserHU);

      await service.signup(signupWithLang);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({ language: Language.HU }),
      });
    });

    it('should create a new user with specified language PL', async () => {
      const signupWithLang = { ...signupDto, language: Language.PL };
      const mockUserPL = { ...mockUser, language: Language.PL };
      mockPrismaService.user.create.mockResolvedValue(mockUserPL);

      await service.signup(signupWithLang);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({ language: Language.PL }),
      });
    });

    it('should throw ConflictException if user already exists', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue(mockUser);

      await expect(service.signup(signupDto)).rejects.toThrow(ConflictException);
    });

    it('should hash the password before saving', async () => {
      await service.signup(signupDto);

      expect(bcrypt.hash).toHaveBeenCalledWith('password123', 12);
    });

    it('should generate JWT tokens after successful signup', async () => {
      const result = await service.signup(signupDto);

      expect(mockJwtService.signAsync).toHaveBeenCalledTimes(2);
      expect(result.accessToken).toBeDefined();
      expect(result.refreshToken).toBeDefined();
    });

    it('should store refresh token in database', async () => {
      await service.signup(signupDto);

      expect(mockPrismaService.refreshToken.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          userId: 'user-123',
          token: expect.any(String),
          expiresAt: expect.any(Date),
        }),
      });
    });

    it('should lowercase email before saving', async () => {
      const upperCaseEmail = { ...signupDto, email: 'TEST@EXAMPLE.COM' };

      await service.signup(upperCaseEmail);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          email: 'test@example.com',
        }),
      });
    });
  });

  describe('login', () => {
    const loginDto = {
      email: 'test@example.com',
      password: 'password123',
    };

    const mockUser = {
      id: 'user-123',
      email: 'test@example.com',
      hashedPassword: 'hashedPassword',
      language: 'RO',
    };

    beforeEach(() => {
      mockPrismaService.user.findUnique.mockResolvedValue(mockUser);
      (bcrypt.compare as jest.Mock).mockResolvedValue(true);
      mockJwtService.signAsync.mockResolvedValue('mock-token');
      mockPrismaService.refreshToken.create.mockResolvedValue({});
    });

    it('should return user with language in response', async () => {
      const result = await service.login(loginDto);

      expect(result.user.language).toBe('RO');
    });

    it('should throw UnauthorizedException if user not found', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue(null);

      await expect(service.login(loginDto)).rejects.toThrow(UnauthorizedException);
    });

    it('should throw UnauthorizedException if password is invalid', async () => {
      (bcrypt.compare as jest.Mock).mockResolvedValue(false);

      await expect(service.login(loginDto)).rejects.toThrow(UnauthorizedException);
    });
  });
});

