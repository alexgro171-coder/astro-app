import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { NatalPlacementsDto } from './dto/natal-placement.dto';

@Injectable()
export class NatalChartRenderService {
  private readonly logger = new Logger(NatalChartRenderService.name);

  constructor(private prisma: PrismaService) {}

  /**
   * Get or generate SVG wheel chart for user
   */
  async getWheelSvg(userId: string): Promise<string | null> {
    // Check if cached
    const cached = await this.prisma.natalChartWheel.findUnique({
      where: { userId },
    });

    if (cached) {
      return cached.wheelSvg;
    }

    // Get placements
    const placements = await this.prisma.natalPlacements.findUnique({
      where: { userId },
    });

    if (!placements) {
      return null;
    }

    // Generate SVG
    const svg = this.generateSvgWheel(placements.placementsJson as unknown as NatalPlacementsDto);

    // Cache it
    await this.prisma.natalChartWheel.create({
      data: {
        userId,
        placementsId: placements.id,
        wheelSvg: svg,
      },
    });

    return svg;
  }

  /**
   * Generate SVG wheel chart
   */
  private generateSvgWheel(placements: NatalPlacementsDto): string {
    const size = 400;
    const center = size / 2;
    const outerRadius = 180;
    const zodiacRadius = 160;
    const houseRadius = 120;
    const planetRadius = 90;

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

    let svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${size} ${size}" width="${size}" height="${size}">
  <defs>
    <linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#1a1a2e;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#0f0f1a;stop-opacity:1" />
    </linearGradient>
    <filter id="glow">
      <feGaussianBlur stdDeviation="2" result="coloredBlur"/>
      <feMerge>
        <feMergeNode in="coloredBlur"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
  </defs>
  
  <!-- Background -->
  <circle cx="${center}" cy="${center}" r="${outerRadius + 15}" fill="url(#bgGradient)" />
  
  <!-- Outer ring -->
  <circle cx="${center}" cy="${center}" r="${outerRadius}" fill="none" stroke="#9b59b6" stroke-width="2" opacity="0.6" />
  
  <!-- Zodiac ring -->
  <circle cx="${center}" cy="${center}" r="${zodiacRadius}" fill="none" stroke="#9b59b6" stroke-width="1" opacity="0.4" />
  
  <!-- House ring -->
  <circle cx="${center}" cy="${center}" r="${houseRadius}" fill="none" stroke="#9b59b6" stroke-width="1" opacity="0.3" />
  
  <!-- Inner ring (planets) -->
  <circle cx="${center}" cy="${center}" r="${planetRadius}" fill="none" stroke="#9b59b6" stroke-width="0.5" opacity="0.2" />`;

    // Draw zodiac divisions and symbols
    for (let i = 0; i < 12; i++) {
      const angle = (i * 30 - 90) * (Math.PI / 180);
      const x1 = center + zodiacRadius * Math.cos(angle);
      const y1 = center + zodiacRadius * Math.sin(angle);
      const x2 = center + outerRadius * Math.cos(angle);
      const y2 = center + outerRadius * Math.sin(angle);

      svg += `
  <line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" stroke="#9b59b6" stroke-width="1" opacity="0.3" />`;

      // Sign symbol
      const symbolAngle = ((i * 30) + 15 - 90) * (Math.PI / 180);
      const sx = center + (zodiacRadius + (outerRadius - zodiacRadius) / 2) * Math.cos(symbolAngle);
      const sy = center + (zodiacRadius + (outerRadius - zodiacRadius) / 2) * Math.sin(symbolAngle);
      const signColor = zodiacColors[zodiacNames[i]] || '#ffffff';

      svg += `
  <text x="${sx}" y="${sy}" text-anchor="middle" dominant-baseline="middle" 
        font-size="14" fill="${signColor}" font-family="serif">${zodiacSigns[i]}</text>`;
    }

    // Draw house divisions if available
    if (placements.houses && placements.houses.length > 0) {
      for (const house of placements.houses) {
        const angle = (house.cuspLongitude - 90) * (Math.PI / 180);
        const x1 = center + 50 * Math.cos(angle);
        const y1 = center + 50 * Math.sin(angle);
        const x2 = center + zodiacRadius * Math.cos(angle);
        const y2 = center + zodiacRadius * Math.sin(angle);

        svg += `
  <line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" stroke="#6c5ce7" stroke-width="1" opacity="0.5" />`;

        // House number
        const labelAngle = (house.cuspLongitude + 15 - 90) * (Math.PI / 180);
        const lx = center + (houseRadius - 15) * Math.cos(labelAngle);
        const ly = center + (houseRadius - 15) * Math.sin(labelAngle);

        svg += `
  <text x="${lx}" y="${ly}" text-anchor="middle" dominant-baseline="middle" 
        font-size="10" fill="#a29bfe" font-family="sans-serif">${house.house}</text>`;
      }
    }

    // Draw planets
    const planetPositions: { angle: number; symbol: string; color: string }[] = [];
    
    for (const planet of placements.planets) {
      const symbol = planetSymbols[planet.planet] || '●';
      const signIndex = zodiacNames.indexOf(planet.sign);
      
      // Use longitude if available, otherwise estimate from sign
      let longitude = planet.longitude;
      if (!longitude && signIndex >= 0) {
        longitude = signIndex * 30 + 15; // Middle of the sign
      }

      planetPositions.push({
        angle: longitude,
        symbol,
        color: zodiacColors[planet.sign] || '#ffffff',
      });
    }

    // Spread overlapping planets
    const spreadPositions = this.spreadPlanetPositions(planetPositions, 15);

    for (const pos of spreadPositions) {
      const angle = (pos.angle - 90) * (Math.PI / 180);
      const px = center + planetRadius * Math.cos(angle);
      const py = center + planetRadius * Math.sin(angle);

      // Line from planet to zodiac ring
      const zx = center + zodiacRadius * Math.cos(angle);
      const zy = center + zodiacRadius * Math.sin(angle);

      svg += `
  <line x1="${px}" y1="${py}" x2="${zx}" y2="${zy}" stroke="${pos.color}" stroke-width="0.5" opacity="0.3" />
  <text x="${px}" y="${py}" text-anchor="middle" dominant-baseline="middle" 
        font-size="16" fill="${pos.color}" filter="url(#glow)" font-family="serif">${pos.symbol}</text>`;
    }

    // Ascendant marker
    if (placements.ascendantLongitude) {
      const ascAngle = (placements.ascendantLongitude - 90) * (Math.PI / 180);
      const ax1 = center + (outerRadius - 5) * Math.cos(ascAngle);
      const ay1 = center + (outerRadius - 5) * Math.sin(ascAngle);
      const ax2 = center + (outerRadius + 5) * Math.cos(ascAngle);
      const ay2 = center + (outerRadius + 5) * Math.sin(ascAngle);

      svg += `
  <line x1="${ax1}" y1="${ay1}" x2="${ax2}" y2="${ay2}" stroke="#e74c3c" stroke-width="3" />
  <text x="${ax2 + 10}" y="${ay2}" font-size="10" fill="#e74c3c" font-family="sans-serif">ASC</text>`;
    }

    // Midheaven marker
    if (placements.midheavenLongitude) {
      const mcAngle = (placements.midheavenLongitude - 90) * (Math.PI / 180);
      const mx1 = center + (outerRadius - 5) * Math.cos(mcAngle);
      const my1 = center + (outerRadius - 5) * Math.sin(mcAngle);
      const mx2 = center + (outerRadius + 5) * Math.cos(mcAngle);
      const my2 = center + (outerRadius + 5) * Math.sin(mcAngle);

      svg += `
  <line x1="${mx1}" y1="${my1}" x2="${mx2}" y2="${my2}" stroke="#3498db" stroke-width="3" />
  <text x="${mx2 + 10}" y="${my2}" font-size="10" fill="#3498db" font-family="sans-serif">MC</text>`;
    }

    svg += `
</svg>`;

    return svg;
  }

  /**
   * Spread overlapping planets
   */
  private spreadPlanetPositions(
    positions: { angle: number; symbol: string; color: string }[],
    minSpread: number,
  ): { angle: number; symbol: string; color: string }[] {
    const sorted = [...positions].sort((a, b) => a.angle - b.angle);
    
    for (let i = 1; i < sorted.length; i++) {
      const diff = sorted[i].angle - sorted[i - 1].angle;
      if (diff < minSpread) {
        sorted[i].angle = sorted[i - 1].angle + minSpread;
      }
    }

    // Wrap around check
    if (sorted.length > 1) {
      const firstLast = 360 - sorted[sorted.length - 1].angle + sorted[0].angle;
      if (firstLast < minSpread) {
        sorted[sorted.length - 1].angle -= (minSpread - firstLast) / 2;
        sorted[0].angle += (minSpread - firstLast) / 2;
      }
    }

    return sorted;
  }
}

