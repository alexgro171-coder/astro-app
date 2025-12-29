import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { NatalPlacementsDto } from './dto/natal-placement.dto';

@Injectable()
export class NatalChartRenderService {
  private readonly logger = new Logger(NatalChartRenderService.name);

  constructor(private prisma: PrismaService) {}

  /**
   * Get or generate SVG wheel chart for user
   * @param forceRegenerate - If true, ignores cache and regenerates
   */
  async getWheelSvg(userId: string, forceRegenerate = false): Promise<string | null> {
    // Check if cached (unless force regenerate)
    if (!forceRegenerate) {
      const cached = await this.prisma.natalChartWheel.findUnique({
        where: { userId },
      });

      if (cached) {
        return cached.wheelSvg;
      }
    }

    // Get placements
    const placements = await this.prisma.natalPlacements.findUnique({
      where: { userId },
    });

    if (!placements) {
      return null;
    }

    // Generate SVG with Western astrology orientation
    this.logger.log(`Generating Western-style natal chart wheel for user ${userId}`);
    const svg = this.generateSvgWheel(placements.placementsJson as unknown as NatalPlacementsDto);

    // Upsert cache (create or update)
    await this.prisma.natalChartWheel.upsert({
      where: { userId },
      update: {
        wheelSvg: svg,
        updatedAt: new Date(),
      },
      create: {
        userId,
        placementsId: placements.id,
        wheelSvg: svg,
      },
    });

    return svg;
  }

  /**
   * Invalidate cached SVG for a user (forces regeneration on next request)
   */
  async invalidateCache(userId: string): Promise<void> {
    await this.prisma.natalChartWheel.deleteMany({
      where: { userId },
    });
    this.logger.log(`Invalidated wheel SVG cache for user ${userId}`);
  }

  /**
   * Invalidate all cached SVGs (useful after chart rendering algorithm changes)
   */
  async invalidateAllCaches(): Promise<number> {
    const result = await this.prisma.natalChartWheel.deleteMany({});
    this.logger.log(`Invalidated ${result.count} wheel SVG caches`);
    return result.count;
  }

  /**
   * Generate SVG wheel chart - Western Astrology Style
   * 
   * Western chart orientation:
   * - Ascendant (AC) is ALWAYS at the LEFT (9 o'clock position = 180°)
   * - Houses are numbered COUNTER-CLOCKWISE
   * - MC is at the TOP, IC at the BOTTOM, DC at the RIGHT
   * 
   * Coordinate transformation:
   * SVG angle = 180 - (zodiacal_longitude - ascendant_longitude)
   * This places the Ascendant at the left and rotates counter-clockwise
   */
  private generateSvgWheel(placements: NatalPlacementsDto): string {
    const size = 400;
    const center = size / 2;
    const outerRadius = 180;
    const zodiacRadius = 160;
    const houseRadius = 130;
    const houseLabelRadius = 100;
    const planetRadius = 70;
    const innerRadius = 40;

    // Get ascendant for chart orientation
    // Priority: 1) ascendantLongitude, 2) House 1 cusp, 3) fallback to 0
    let ascendant = placements.ascendantLongitude;
    
    // If no ascendant, use House 1 cusp (which IS the Ascendant by definition)
    if (ascendant === undefined || ascendant === null) {
      const house1 = placements.houses?.find(h => h.house === 1);
      if (house1) {
        ascendant = house1.cuspLongitude;
        this.logger.log(`Using House 1 cusp (${ascendant}°) as Ascendant`);
      }
    }
    
    // Final fallback to 0° Aries
    ascendant = ascendant ?? 0;
    
    this.logger.log(`Chart orientation: Ascendant at ${ascendant}° zodiacal longitude`);

    const zodiacSigns = ['♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓'];
    const zodiacNames = ['Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 
                         'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'];
    
    const planetSymbols: Record<string, string> = {
      'Sun': '☉',
      'Moon': '☽',
      'Mercury': '☿',
      'Venus': '♀',
      'Mars': '♂',
      'Jupiter': '♃',
      'Saturn': '♄',
      'Uranus': '♅',
      'Neptune': '♆',
      'Pluto': '♇',
      'North Node': '☊',
      'South Node': '☋',
      'Chiron': '⚷',
    };

    const zodiacColors: Record<string, string> = {
      'Aries': '#FF4136',
      'Leo': '#FF851B',
      'Sagittarius': '#B10DC9',
      'Taurus': '#2ECC40',
      'Virgo': '#85144b',
      'Capricorn': '#3D9970',
      'Gemini': '#FFDC00',
      'Libra': '#FF69B4',
      'Aquarius': '#7FDBFF',
      'Cancer': '#C0C0C0',
      'Scorpio': '#8B0000',
      'Pisces': '#0074D9',
    };

    /**
     * Convert zodiacal longitude to SVG angle (in degrees)
     * Places Ascendant at 180° (left side) with counter-clockwise progression
     */
    const longitudeToSvgAngle = (longitude: number): number => {
      // Counter-clockwise from Ascendant at left (180°)
      return 180 - (longitude - ascendant);
    };

    /**
     * Convert SVG angle (degrees) to radians for Math functions
     */
    const toRadians = (degrees: number): number => degrees * (Math.PI / 180);

    /**
     * Get x,y coordinates from SVG angle and radius
     */
    const getPoint = (angleDeg: number, radius: number): { x: number; y: number } => {
      const rad = toRadians(angleDeg);
      return {
        x: center + radius * Math.cos(rad),
        y: center + radius * Math.sin(rad),
      };
    };

    let svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${size} ${size}" width="${size}" height="${size}">
  <defs>
    <linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#1a1a2e;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#0f0f1a;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="chartBg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#faf8f5;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#f0ebe3;stop-opacity:1" />
    </linearGradient>
    <filter id="glow">
      <feGaussianBlur stdDeviation="1.5" result="coloredBlur"/>
      <feMerge>
        <feMergeNode in="coloredBlur"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
    <filter id="shadow">
      <feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity="0.3"/>
    </filter>
  </defs>
  
  <!-- Background circle -->
  <circle cx="${center}" cy="${center}" r="${outerRadius + 15}" fill="url(#bgGradient)" />
  
  <!-- Chart background (cream/beige like traditional charts) -->
  <circle cx="${center}" cy="${center}" r="${outerRadius}" fill="url(#chartBg)" />
  
  <!-- Zodiac outer ring background -->
  <circle cx="${center}" cy="${center}" r="${outerRadius}" fill="none" stroke="#333" stroke-width="1" />
  <circle cx="${center}" cy="${center}" r="${zodiacRadius}" fill="none" stroke="#333" stroke-width="1" />
  
  <!-- House circle -->
  <circle cx="${center}" cy="${center}" r="${houseRadius}" fill="none" stroke="#666" stroke-width="0.5" />
  
  <!-- Inner circle -->
  <circle cx="${center}" cy="${center}" r="${innerRadius}" fill="#f5f5f0" stroke="#333" stroke-width="0.5" />`;

    // Draw zodiac sign divisions and symbols (counter-clockwise from Ascendant)
    for (let i = 0; i < 12; i++) {
      const signStartLongitude = i * 30; // 0°, 30°, 60°... in zodiac
      const signEndLongitude = (i + 1) * 30;
      
      // Convert to SVG angles
      const startAngle = longitudeToSvgAngle(signStartLongitude);
      const endAngle = longitudeToSvgAngle(signEndLongitude);
      
      // Draw division line at sign boundary
      const p1 = getPoint(startAngle, zodiacRadius);
      const p2 = getPoint(startAngle, outerRadius);

      svg += `
  <line x1="${p1.x}" y1="${p1.y}" x2="${p2.x}" y2="${p2.y}" stroke="#333" stroke-width="0.5" />`;

      // Sign symbol (placed in middle of sign sector)
      const midAngle = (startAngle + endAngle) / 2;
      const symbolRadius = zodiacRadius + (outerRadius - zodiacRadius) / 2;
      const sp = getPoint(midAngle, symbolRadius);
      const signColor = zodiacColors[zodiacNames[i]] || '#333';

      svg += `
  <text x="${sp.x}" y="${sp.y}" text-anchor="middle" dominant-baseline="middle" 
        font-size="14" fill="${signColor}" font-weight="bold" font-family="serif">${zodiacSigns[i]}</text>`;
    }

    // Draw house divisions and numbers
    if (placements.houses && placements.houses.length > 0) {
      // Sort houses by number
      const sortedHouses = [...placements.houses].sort((a, b) => a.house - b.house);
      
      for (let i = 0; i < sortedHouses.length; i++) {
        const house = sortedHouses[i];
        const nextHouse = sortedHouses[(i + 1) % 12];
        
        // House cusp line
        const cuspAngle = longitudeToSvgAngle(house.cuspLongitude);
        const p1 = getPoint(cuspAngle, innerRadius);
        const p2 = getPoint(cuspAngle, zodiacRadius);
        
        // Thicker lines for angular houses (1, 4, 7, 10)
        const isAngular = [1, 4, 7, 10].includes(house.house);
        const strokeWidth = isAngular ? 2 : 0.5;
        const strokeColor = isAngular ? '#000' : '#666';

        svg += `
  <line x1="${p1.x}" y1="${p1.y}" x2="${p2.x}" y2="${p2.y}" stroke="${strokeColor}" stroke-width="${strokeWidth}" />`;

        // House number (placed between this cusp and next cusp)
        const nextCuspAngle = longitudeToSvgAngle(nextHouse.cuspLongitude);
        // Calculate middle angle (handle wrap-around)
        let midAngle = (cuspAngle + nextCuspAngle) / 2;
        if (Math.abs(cuspAngle - nextCuspAngle) > 180) {
          midAngle = (cuspAngle + nextCuspAngle + 360) / 2;
          if (midAngle > 360) midAngle -= 360;
        }
        
        const lp = getPoint(midAngle, houseLabelRadius);

        svg += `
  <text x="${lp.x}" y="${lp.y}" text-anchor="middle" dominant-baseline="middle" 
        font-size="11" fill="#444" font-family="sans-serif" font-weight="bold">${house.house}</text>`;
      }
    } else {
      // No house data - draw equal houses from Ascendant
      for (let i = 0; i < 12; i++) {
        const houseStartLongitude = ascendant + (i * 30);
        const cuspAngle = longitudeToSvgAngle(houseStartLongitude);
        
        const p1 = getPoint(cuspAngle, innerRadius);
        const p2 = getPoint(cuspAngle, zodiacRadius);
        
        const isAngular = [0, 3, 6, 9].includes(i); // Houses 1, 4, 7, 10
        const strokeWidth = isAngular ? 2 : 0.5;

        svg += `
  <line x1="${p1.x}" y1="${p1.y}" x2="${p2.x}" y2="${p2.y}" stroke="#666" stroke-width="${strokeWidth}" />`;

        // House number
        const nextCuspAngle = longitudeToSvgAngle(houseStartLongitude + 30);
        const midAngle = (cuspAngle + nextCuspAngle) / 2;
        const lp = getPoint(midAngle, houseLabelRadius);
        const houseNum = i + 1;

        svg += `
  <text x="${lp.x}" y="${lp.y}" text-anchor="middle" dominant-baseline="middle" 
        font-size="11" fill="#444" font-family="sans-serif" font-weight="bold">${houseNum}</text>`;
      }
    }

    // Draw planets
    const planetPositions: { longitude: number; symbol: string; color: string; planet: string }[] = [];
    
    for (const planet of placements.planets) {
      const symbol = planetSymbols[planet.planet] || '●';
      const signIndex = zodiacNames.indexOf(planet.sign);
      
      // Use longitude if available, otherwise estimate from sign
      let longitude = planet.longitude ?? 0;
      if (!planet.longitude && signIndex >= 0) {
        longitude = signIndex * 30 + 15; // Middle of the sign
      }

      planetPositions.push({
        longitude,
        symbol,
        color: zodiacColors[planet.sign] || '#333',
        planet: planet.planet,
      });
    }

    // Spread overlapping planets
    const spreadPositions = this.spreadPlanetPositionsWestern(planetPositions, 12);

    for (const pos of spreadPositions) {
      const angle = longitudeToSvgAngle(pos.longitude);
      const pp = getPoint(angle, planetRadius);

      // Line from planet position to zodiac ring (shows actual position)
      const actualAngle = longitudeToSvgAngle(pos.originalLongitude);
      const zp = getPoint(actualAngle, zodiacRadius - 5);
      const innerP = getPoint(actualAngle, houseRadius + 5);

      svg += `
  <line x1="${innerP.x}" y1="${innerP.y}" x2="${zp.x}" y2="${zp.y}" stroke="${pos.color}" stroke-width="1" opacity="0.5" />
  <text x="${pp.x}" y="${pp.y}" text-anchor="middle" dominant-baseline="middle" 
        font-size="14" fill="${pos.color}" filter="url(#glow)" font-family="serif" font-weight="bold">${pos.symbol}</text>`;
    }

    // Draw axis labels (AC, DC, MC, IC)
    // AC (Ascendant) - always at left (180°)
    const acPoint = getPoint(180, outerRadius + 12);
    svg += `
  <text x="${acPoint.x - 15}" y="${acPoint.y}" text-anchor="end" dominant-baseline="middle" 
        font-size="12" fill="#e74c3c" font-weight="bold" font-family="sans-serif">AC</text>`;

    // DC (Descendant) - always at right (0°)
    const dcPoint = getPoint(0, outerRadius + 12);
    svg += `
  <text x="${dcPoint.x + 15}" y="${dcPoint.y}" text-anchor="start" dominant-baseline="middle" 
        font-size="12" fill="#3498db" font-weight="bold" font-family="sans-serif">DC</text>`;

    // MC (Midheaven) - at top (90°)
    if (placements.midheavenLongitude) {
      const mcAngle = longitudeToSvgAngle(placements.midheavenLongitude);
      const mcPoint = getPoint(mcAngle, outerRadius + 12);
      svg += `
  <text x="${mcPoint.x}" y="${mcPoint.y - 5}" text-anchor="middle" dominant-baseline="auto" 
        font-size="12" fill="#27ae60" font-weight="bold" font-family="sans-serif">MC</text>`;
    } else {
      // Default MC at top
      const mcPoint = getPoint(90, outerRadius + 12);
      svg += `
  <text x="${mcPoint.x}" y="${mcPoint.y - 5}" text-anchor="middle" dominant-baseline="auto" 
        font-size="12" fill="#27ae60" font-weight="bold" font-family="sans-serif">MC</text>`;
    }

    // IC (Imum Coeli) - at bottom (270°)
    const icAngle = placements.midheavenLongitude 
      ? longitudeToSvgAngle(placements.midheavenLongitude + 180)
      : 270;
    const icPoint = getPoint(icAngle, outerRadius + 12);
    svg += `
  <text x="${icPoint.x}" y="${icPoint.y + 15}" text-anchor="middle" dominant-baseline="hanging" 
        font-size="12" fill="#8e44ad" font-weight="bold" font-family="sans-serif">IC</text>`;

    // Draw horizontal and vertical axis lines through center
    // Horizon line (AC-DC)
    svg += `
  <line x1="${center - outerRadius}" y1="${center}" x2="${center + outerRadius}" y2="${center}" 
        stroke="#000" stroke-width="1.5" />`;
    
    // Meridian line (MC-IC) - rotated based on actual MC position
    if (placements.midheavenLongitude) {
      const mcAngle = longitudeToSvgAngle(placements.midheavenLongitude);
      const icAngle = longitudeToSvgAngle(placements.midheavenLongitude + 180);
      const mcP = getPoint(mcAngle, outerRadius);
      const icP = getPoint(icAngle, outerRadius);
      svg += `
  <line x1="${mcP.x}" y1="${mcP.y}" x2="${icP.x}" y2="${icP.y}" stroke="#000" stroke-width="1" />`;
    } else {
      svg += `
  <line x1="${center}" y1="${center - outerRadius}" x2="${center}" y2="${center + outerRadius}" 
        stroke="#000" stroke-width="1" />`;
    }

    svg += `
</svg>`;

    return svg;
  }

  /**
   * Spread overlapping planets for Western chart (counter-clockwise)
   */
  private spreadPlanetPositionsWestern(
    positions: { longitude: number; symbol: string; color: string; planet: string }[],
    minSpread: number,
  ): { longitude: number; originalLongitude: number; symbol: string; color: string }[] {
    // Sort by longitude
    const sorted = positions
      .map(p => ({ ...p, originalLongitude: p.longitude }))
      .sort((a, b) => a.longitude - b.longitude);
    
    // Spread overlapping planets
    for (let i = 1; i < sorted.length; i++) {
      const diff = sorted[i].longitude - sorted[i - 1].longitude;
      if (diff < minSpread && diff >= 0) {
        sorted[i].longitude = sorted[i - 1].longitude + minSpread;
      }
    }

    // Handle wrap-around (last and first planet)
    if (sorted.length > 1) {
      const wrapDiff = 360 - sorted[sorted.length - 1].longitude + sorted[0].longitude;
      if (wrapDiff < minSpread && wrapDiff >= 0) {
        // Adjust both to spread them
        sorted[sorted.length - 1].longitude -= (minSpread - wrapDiff) / 2;
        sorted[0].longitude += (minSpread - wrapDiff) / 2;
      }
    }

    // Normalize angles back to 0-360
    return sorted.map(p => ({
      ...p,
      longitude: ((p.longitude % 360) + 360) % 360,
    }));
  }

}

