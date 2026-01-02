import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException } from '@nestjs/common';
import { Language } from '@prisma/client';
import { UsersService } from './users.service';
import { PrismaService } from '../prisma/prisma.service';
import { AstrologyService } from '../astrology/astrology.service';

describe('UsersService - Language Update', () => {
  let service: UsersService;

  const mockPrismaService = {
    user: {
      findUnique: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    },
    userDevice: {
      upsert: jest.fn(),
      updateMany: jest.fn(),
    },
  };

  const mockAstrologyService = {
    getGeoDetails: jest.fn(),
    getTimezone: jest.fn(),
    generateNatalChart: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: AstrologyService, useValue: mockAstrologyService },
      ],
    }).compile();

    service = module.get<UsersService>(UsersService);

    jest.clearAllMocks();
  });

  describe('getProfile', () => {
    const mockUser = {
      id: 'user-123',
      email: 'test@example.com',
      name: 'Test User',
      language: Language.RO,
      hashedPassword: 'hashedPassword',
      natalChart: {
        sunSign: 'Aries',
        moonSign: 'Taurus',
        ascendant: 'Gemini',
        createdAt: new Date(),
      },
    };

    it('should return user profile with language', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue(mockUser);

      const result = await service.getProfile('user-123');

      expect(result.language).toBe(Language.RO);
      expect(result).not.toHaveProperty('hashedPassword');
    });

    it('should throw NotFoundException if user not found', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue(null);

      await expect(service.getProfile('invalid-id')).rejects.toThrow(NotFoundException);
    });
  });

  describe('updateProfile - Language Update', () => {
    const mockUser = {
      id: 'user-123',
      email: 'test@example.com',
      name: 'Test User',
      language: Language.EN,
      hashedPassword: 'hashedPassword',
    };

    beforeEach(() => {
      mockPrismaService.user.update.mockResolvedValue(mockUser);
    });

    it('should update language to RO', async () => {
      const updatedUser = { ...mockUser, language: Language.RO };
      mockPrismaService.user.update.mockResolvedValue(updatedUser);

      const result = await service.updateProfile('user-123', { language: Language.RO });

      expect(mockPrismaService.user.update).toHaveBeenCalledWith({
        where: { id: 'user-123' },
        data: { language: Language.RO },
      });
      expect(result.language).toBe(Language.RO);
    });

    it('should update language to FR', async () => {
      const updatedUser = { ...mockUser, language: Language.FR };
      mockPrismaService.user.update.mockResolvedValue(updatedUser);

      const result = await service.updateProfile('user-123', { language: Language.FR });

      expect(mockPrismaService.user.update).toHaveBeenCalledWith({
        where: { id: 'user-123' },
        data: { language: Language.FR },
      });
      expect(result.language).toBe(Language.FR);
    });

    it('should update language to DE', async () => {
      const updatedUser = { ...mockUser, language: Language.DE };
      mockPrismaService.user.update.mockResolvedValue(updatedUser);

      const result = await service.updateProfile('user-123', { language: Language.DE });

      expect(result.language).toBe(Language.DE);
    });

    it('should update language to ES', async () => {
      const updatedUser = { ...mockUser, language: Language.ES };
      mockPrismaService.user.update.mockResolvedValue(updatedUser);

      const result = await service.updateProfile('user-123', { language: Language.ES });

      expect(result.language).toBe(Language.ES);
    });

    it('should update language to IT', async () => {
      const updatedUser = { ...mockUser, language: Language.IT };
      mockPrismaService.user.update.mockResolvedValue(updatedUser);

      const result = await service.updateProfile('user-123', { language: Language.IT });

      expect(result.language).toBe(Language.IT);
    });

    it('should update language to HU', async () => {
      const updatedUser = { ...mockUser, language: Language.HU };
      mockPrismaService.user.update.mockResolvedValue(updatedUser);

      const result = await service.updateProfile('user-123', { language: Language.HU });

      expect(result.language).toBe(Language.HU);
    });

    it('should update language to PL', async () => {
      const updatedUser = { ...mockUser, language: Language.PL };
      mockPrismaService.user.update.mockResolvedValue(updatedUser);

      const result = await service.updateProfile('user-123', { language: Language.PL });

      expect(result.language).toBe(Language.PL);
    });

    it('should not include hashedPassword in response', async () => {
      const result = await service.updateProfile('user-123', { language: Language.EN });

      expect(result).not.toHaveProperty('hashedPassword');
    });

    it('should allow updating multiple fields including language', async () => {
      const updatedUser = { ...mockUser, name: 'New Name', language: Language.ES };
      mockPrismaService.user.update.mockResolvedValue(updatedUser);

      const result = await service.updateProfile('user-123', {
        name: 'New Name',
        language: Language.ES,
      });

      expect(mockPrismaService.user.update).toHaveBeenCalledWith({
        where: { id: 'user-123' },
        data: {
          name: 'New Name',
          language: Language.ES,
        },
      });
      expect(result.language).toBe(Language.ES);
      expect(result.name).toBe('New Name');
    });
  });

  describe('Language Validation', () => {
    // Note: Actual validation is done at DTO level with class-validator
    // These tests verify the service accepts valid language codes
    const validLanguages = [
      Language.EN,
      Language.RO,
      Language.FR,
      Language.DE,
      Language.ES,
      Language.IT,
      Language.HU,
      Language.PL,
    ];

    validLanguages.forEach((lang) => {
      it(`should accept valid language code: ${lang}`, async () => {
        const mockUser = { id: 'user-123', language: lang, hashedPassword: 'hash' };
        mockPrismaService.user.update.mockResolvedValue(mockUser);

        const result = await service.updateProfile('user-123', { language: lang });

        expect(result.language).toBe(lang);
      });
    });
  });
});
