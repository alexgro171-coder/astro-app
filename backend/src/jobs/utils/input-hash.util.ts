import * as crypto from 'crypto';

/**
 * Compute SHA256 hash of normalized input for idempotency checks.
 */
export function computeInputHash(input: Record<string, any>): string {
  // Sort keys for consistent ordering
  const normalized = JSON.stringify(sortObjectKeys(input));
  return crypto.createHash('sha256').update(normalized).digest('hex');
}

/**
 * Recursively sort object keys for consistent hashing.
 */
function sortObjectKeys(obj: any): any {
  if (obj === null || typeof obj !== 'object') {
    return obj;
  }

  if (Array.isArray(obj)) {
    return obj.map(sortObjectKeys);
  }

  const sorted: Record<string, any> = {};
  const keys = Object.keys(obj).sort();
  
  for (const key of keys) {
    sorted[key] = sortObjectKeys(obj[key]);
  }
  
  return sorted;
}

