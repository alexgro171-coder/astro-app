import * as crypto from 'crypto';
import { OneTimeServiceType } from '@prisma/client';
import { PartnerProfileDto } from '../dto/partner-profile.dto';

export interface InputHashData {
  serviceType: OneTimeServiceType;
  locale: string;
  userNatal: {
    birthDate: string;
    birthTime?: string;
    birthLat?: number;
    birthLon?: number;
    birthTimezone?: number;
  };
  partner?: PartnerProfileDto;
  date?: string; // For Moon Phase report
}

/**
 * Compute a deterministic SHA256 hash from the input data.
 * This ensures idempotency - same input always produces same hash.
 */
export function computeInputHash(data: InputHashData): string {
  // Normalize the data to ensure consistent hashing
  const normalized = {
    serviceType: data.serviceType,
    locale: data.locale.toLowerCase(),
    userNatal: {
      birthDate: data.userNatal.birthDate,
      birthTime: data.userNatal.birthTime || null,
      birthLat: data.userNatal.birthLat ? Number(data.userNatal.birthLat.toFixed(4)) : null,
      birthLon: data.userNatal.birthLon ? Number(data.userNatal.birthLon.toFixed(4)) : null,
      birthTimezone: data.userNatal.birthTimezone ?? null,
    },
    partner: data.partner
      ? {
          birthDate: data.partner.birthDate,
          birthTime: data.partner.birthTime || null,
          lat: data.partner.lat ? Number(data.partner.lat.toFixed(4)) : null,
          lon: data.partner.lon ? Number(data.partner.lon.toFixed(4)) : null,
          timezone: data.partner.timezone ?? null,
        }
      : null,
    date: data.date || null,
  };

  const jsonString = JSON.stringify(normalized, Object.keys(normalized).sort());
  return crypto.createHash('sha256').update(jsonString).digest('hex');
}

