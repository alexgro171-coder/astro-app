import { Test, TestingModule } from '@nestjs/testing';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { Language } from '@prisma/client';
import { FirebaseAuthService } from './firebase-auth.service';
import { PrismaService } from '../prisma/prisma.service';
import { AnalyticsService } from '../analytics/analytics.service';
import { FirebaseAuthProvider } from './dto/firebase-auth.dto';
import * as admin from 'firebase-admin';

// Mock firebase-admin
jest.mock('firebase-admin', () => ({
  apps: [],
  initializeApp: jest.fn(),
  credential: {
    cert: jest.fn(),
  },
  auth: jest.fn(() => ({
    verifyIdToken: jest.fn(),
  })),
}));

describe('FirebaseAuthService', () => {
  let service: FirebaseAuthService;

  const mockPrismaService = {
    user: {
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    refreshToken: {
      create: jest.fn(),
    },
  };

  const mockJwtService = {
    signAsync: jest.fn(),
  };

  const mockConfigService = {
    get: jest.fn((key: string) => {
      const config: Record<string, string> = {
        FIREBASE_PROJECT_ID: 'test-project',
        FIREBASE_PRIVATE_KEY_BASE64: Buffer.from('test-key').toString('base64'),
        FIREBASE_CLIENT_EMAIL: 'test@test.com',
        JWT_SECRET: 'test-secret',
        JWT_REFRESH_SECRET: 'test-refresh-secret',
        JWT_EXPIRES_IN: '7d',
        JWT_REFRESH_EXPIRES_IN: '30d',
      };
      return config[key];
    }),
  };

  const mockAnalyticsService = {
    logEvent: jest.fn().mockResolvedValue(undefined),
  };

  beforeEach(async () => {
    // Reset firebase apps
    (admin as any).apps = [];

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        FirebaseAuthService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: JwtService, useValue: mockJwtService },
        { provide: ConfigService, useValue: mockConfigService },
        { provide: AnalyticsService, useValue: mockAnalyticsService },
      ],
    }).compile();

    service = module.get<FirebaseAuthService>(FirebaseAuthService);

    jest.clearAllMocks();

    // Default mock implementations
    mockJwtService.signAsync.mockResolvedValue('mock-token');
    mockPrismaService.refreshToken.create.mockResolvedValue({});
  });

  describe('authenticateWithFirebase - Language Support', () => {
    const mockDecodedToken = {
      uid: 'firebase-uid-123',
      email: 'test@example.com',
      name: 'Test User',
    };

    const mockNewUser = {
      id: 'user-123',
      email: 'test@example.com',
      name: 'Test User',
      language: Language.EN,
      onboardingComplete: false,
    };

    beforeEach(() => {
      // Mock Firebase token verification
      (admin.auth as jest.Mock).mockReturnValue({
        verifyIdToken: jest.fn().mockResolvedValue(mockDecodedToken),
      });

      // Initialize the service (trigger onModuleInit)
      service.onModuleInit();
    });

    it('should create new user with default language EN when not specified', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue(mockNewUser);

      const dto = {
        idToken: 'valid-token',
        provider: FirebaseAuthProvider.GOOGLE,
        name: 'Test User',
      };

      await service.authenticateWithFirebase(dto);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          language: 'EN',
        }),
      });
    });

    it('should create new user with specified language RO', async () => {
      const mockUserRO = { ...mockNewUser, language: Language.RO };
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue(mockUserRO);

      const dto = {
        idToken: 'valid-token',
        provider: FirebaseAuthProvider.GOOGLE,
        name: 'Test User',
        language: Language.RO,
      };

      await service.authenticateWithFirebase(dto);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          language: Language.RO,
        }),
      });
    });

    it('should create new user with specified language FR', async () => {
      const mockUserFR = { ...mockNewUser, language: Language.FR };
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue(mockUserFR);

      const dto = {
        idToken: 'valid-token',
        provider: FirebaseAuthProvider.GOOGLE,
        language: Language.FR,
      };

      await service.authenticateWithFirebase(dto);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          language: Language.FR,
        }),
      });
    });

    it('should create new user with specified language DE via Apple Sign-In', async () => {
      const mockUserDE = { ...mockNewUser, language: Language.DE };
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue(mockUserDE);

      const dto = {
        idToken: 'valid-token',
        provider: FirebaseAuthProvider.APPLE,
        language: Language.DE,
      };

      await service.authenticateWithFirebase(dto);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          language: Language.DE,
          appleId: mockDecodedToken.uid,
        }),
      });
    });

    it('should create new user with specified language ES', async () => {
      const mockUserES = { ...mockNewUser, language: Language.ES };
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue(mockUserES);

      const dto = {
        idToken: 'valid-token',
        provider: FirebaseAuthProvider.GOOGLE,
        language: Language.ES,
      };

      await service.authenticateWithFirebase(dto);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          language: Language.ES,
        }),
      });
    });

    it('should create new user with specified language IT', async () => {
      const mockUserIT = { ...mockNewUser, language: Language.IT };
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue(mockUserIT);

      const dto = {
        idToken: 'valid-token',
        provider: FirebaseAuthProvider.GOOGLE,
        language: Language.IT,
      };

      await service.authenticateWithFirebase(dto);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          language: Language.IT,
        }),
      });
    });

    it('should create new user with specified language HU', async () => {
      const mockUserHU = { ...mockNewUser, language: Language.HU };
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue(mockUserHU);

      const dto = {
        idToken: 'valid-token',
        provider: FirebaseAuthProvider.GOOGLE,
        language: Language.HU,
      };

      await service.authenticateWithFirebase(dto);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          language: Language.HU,
        }),
      });
    });

    it('should create new user with specified language PL', async () => {
      const mockUserPL = { ...mockNewUser, language: Language.PL };
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue(mockUserPL);

      const dto = {
        idToken: 'valid-token',
        provider: FirebaseAuthProvider.GOOGLE,
        language: Language.PL,
      };

      await service.authenticateWithFirebase(dto);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          language: Language.PL,
        }),
      });
    });

    it('should return user language in response for new users', async () => {
      const mockUserRO = { ...mockNewUser, language: Language.RO };
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue(mockUserRO);

      const dto = {
        idToken: 'valid-token',
        provider: FirebaseAuthProvider.GOOGLE,
        language: Language.RO,
      };

      const result = await service.authenticateWithFirebase(dto);

      expect(result.user.language).toBe(Language.RO);
    });

    it('should return existing user language (not override)', async () => {
      const existingUser = { ...mockNewUser, language: Language.FR, googleId: mockDecodedToken.uid };
      mockPrismaService.user.findUnique.mockResolvedValue(existingUser);

      const dto = {
        idToken: 'valid-token',
        provider: FirebaseAuthProvider.GOOGLE,
        language: Language.DE, // Different language
      };

      const result = await service.authenticateWithFirebase(dto);

      // For existing users, language should NOT be overwritten
      expect(result.user.language).toBe(Language.FR);
      expect(mockPrismaService.user.create).not.toHaveBeenCalled();
    });

    it('should set googleId for Google provider', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue(mockNewUser);

      const dto = {
        idToken: 'valid-token',
        provider: FirebaseAuthProvider.GOOGLE,
        language: Language.EN,
      };

      await service.authenticateWithFirebase(dto);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          googleId: mockDecodedToken.uid,
        }),
      });
    });

    it('should set appleId for Apple provider', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue({ ...mockNewUser, appleId: mockDecodedToken.uid });

      const dto = {
        idToken: 'valid-token',
        provider: FirebaseAuthProvider.APPLE,
        language: Language.EN,
      };

      await service.authenticateWithFirebase(dto);

      expect(mockPrismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          appleId: mockDecodedToken.uid,
        }),
      });
    });
  });
});
