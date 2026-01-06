import { GenerationJobType, User } from '@prisma/client';

/**
 * Build normalized input object for each job type.
 * Used for idempotency checking via hash.
 */
export function buildNormalizedInput(
  jobType: GenerationJobType,
  user: User,
  localDateStr: string,
  payload?: Record<string, any>,
): Record<string, any> {
  switch (jobType) {
    case 'DAILY_GUIDANCE':
      return {
        jobType,
        userId: user.id,
        localDateStr,
        // Include natal chart version if exists
        birthDate: user.birthDate?.toISOString().split('T')[0],
        birthTime: user.birthTime,
        birthLat: user.birthLat,
        birthLon: user.birthLon,
      };

    case 'NATAL_CHART_SHORT':
    case 'NATAL_CHART_PRO':
      return {
        jobType,
        userId: user.id,
        birthDate: user.birthDate?.toISOString().split('T')[0],
        birthTime: user.birthTime,
        birthLat: user.birthLat,
        birthLon: user.birthLon,
        birthTimezone: user.birthTimezone,
      };

    case 'KARMIC_ASTROLOGY':
      return {
        jobType,
        userId: user.id,
        birthDate: user.birthDate?.toISOString().split('T')[0],
        birthTime: user.birthTime,
        birthLat: user.birthLat,
        birthLon: user.birthLon,
        birthTimezone: user.birthTimezone,
      };

    case 'ONE_TIME_REPORT':
      // Include serviceType and partner data from payload
      return {
        jobType,
        userId: user.id,
        serviceType: payload?.serviceType,
        partnerProfile: payload?.partnerProfile,
        date: payload?.date,
        birthDate: user.birthDate?.toISOString().split('T')[0],
        birthTime: user.birthTime,
        birthLat: user.birthLat,
        birthLon: user.birthLon,
      };

    default:
      return {
        jobType,
        userId: user.id,
        localDateStr,
      };
  }
}

/**
 * Get the local date string for a user based on their timezone.
 */
export function getUserLocalDateStr(user: User): string {
  const now = new Date();
  
  // Use IANA timezone if available, otherwise use offset
  if (user.timezoneIana) {
    try {
      const formatter = new Intl.DateTimeFormat('en-CA', {
        timeZone: user.timezoneIana,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      });
      return formatter.format(now); // Returns YYYY-MM-DD format
    } catch (e) {
      // Fallback to offset calculation
    }
  }

  // Fallback: use numeric timezone offset
  const offsetHours = user.birthTimezone || 0;
  const userTime = new Date(now.getTime() + offsetHours * 60 * 60 * 1000);
  return userTime.toISOString().split('T')[0];
}

