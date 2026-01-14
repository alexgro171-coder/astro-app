import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';
import { Language, ConcernCategory } from '@prisma/client';

interface ClassificationResult {
  category: ConcernCategory;
  confidence: number;
  secondaryCategories: ConcernCategory[];
}

interface GuidanceSections {
  dailySummary: { content: string; mood: string; focusArea: string };
  health: { content: string; score: number };
  job: { content: string; score: number };
  business_money: { content: string; score: number };
  love: { content: string; score: number };
  partnerships: { content: string; score: number };
  personal_growth: { content: string; score: number };
}

interface PreviousDayData {
  date: string;
  scores: {
    health: number;
    job: number;
    business_money: number;
    love: number;
    partnerships: number;
    personal_growth: number;
  };
}

/**
 * Personal context from V1 questionnaire (Premium only)
 */
interface PersonalContext {
  summary60w: string;
  tags: {
    gender: string | null; // User's gender for personalized guidance
    relationship_status: string;
    seeking_relationship: boolean | null;
    has_children: boolean;
    children_count: number;
    work_status: string;
    industry: string | null;
    health_score: number;
    social_score: number;
    romance_score: number;
    finance_score: number;
    career_score: number;
    growth_score: number;
    priorities: string[];
    tone_preference: 'direct' | 'empathetic' | 'balanced';
    sensitivity_mode: boolean;
  };
}

interface GuidanceContext {
  natalSummary: any;
  transits: any[];
  previousDays?: PreviousDayData[];
  language: Language;
  userName?: string;
  // Personal context for Premium users
  personalContext?: PersonalContext | null;
}

@Injectable()
export class AiService {
  private readonly logger = new Logger(AiService.name);
  private readonly openai: OpenAI;
  private readonly model: string;

  constructor(private configService: ConfigService) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
    this.model = this.configService.get<string>('OPENAI_MODEL', 'gpt-5-mini');
  }

  /**
   * Classify a user's concern into categories
   */
  async classifyConcern(text: string, language: Language): Promise<ClassificationResult> {
    const systemPrompt = `You are an AI assistant that classifies user concerns into predefined categories.
    
Categories:
- HEALTH: Physical or mental health, energy levels, wellness
- JOB: Career, employment, job search, work environment
- BUSINESS_DECISION: Business decisions, entrepreneurship, strategic choices
- MONEY: Finances, investments, money management
- PARTNERSHIP: Business partnerships, professional collaborations
- COUPLE: Romantic relationships, marriage, dating
- FAMILY: Family relationships, children, parents
- PERSONAL_GROWTH: Self-improvement, education, spirituality, life purpose
- OTHER: Anything that doesn't fit the above

Analyze the text and return a JSON object with:
- category: The primary category (most relevant)
- confidence: A number between 0 and 1 indicating confidence
- secondaryCategories: Array of other relevant categories (if any)

Respond ONLY with valid JSON, no other text.`;

    const userPrompt = `Classify this concern (language: ${language}):

"${text}"`;

    try {
      const response = await this.openai.chat.completions.create({
        model: this.model,
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt },
        ],
        response_format: { type: 'json_object' },
        temperature: 0.3,
        max_tokens: 200,
      });

      const result = JSON.parse(response.choices[0].message.content || '{}');
      
      return {
        category: result.category || 'OTHER',
        confidence: result.confidence || 0.5,
        secondaryCategories: result.secondaryCategories || [],
      };
    } catch (error) {
      this.logger.error('Failed to classify concern:', error.message);
      return {
        category: 'OTHER',
        confidence: 0,
        secondaryCategories: [],
      };
    }
  }

  /**
   * Generate daily guidance based on natal chart, transits, and user context
   * 
   * For Premium users with personal context, guidance is more tailored.
   * Input is kept under 800 words using precomputed summaries.
   */
  async generateDailyGuidance(context: GuidanceContext): Promise<GuidanceSections> {
    const languageInstructions = this.getLanguageInstructions(context.language);

    // Determine tone based on personal context (Premium) or default
    const tonePreference = context.personalContext?.tags?.tone_preference || 'balanced';
    const sensitivityMode = context.personalContext?.tags?.sensitivity_mode || false;

    const toneInstructions = this.getToneInstructions(tonePreference, sensitivityMode);

    // Build previous days context for continuity (compact)
    let previousDaysContext = '';
    if (context.previousDays && context.previousDays.length > 0) {
      previousDaysContext = `
PREVIOUS DAYS (for continuity):
${context.previousDays.map(day => 
  `- ${day.date}: H:${day.scores.health} C:${day.scores.job} M:${day.scores.business_money} L:${day.scores.love} P:${day.scores.partnerships} G:${day.scores.personal_growth}`
).join('\n')}
`;
    }

    // Build personal context section (Premium only, max 60 words)
    let personalContextSection = '';
    if (context.personalContext) {
      const { summary60w, tags } = context.personalContext;
      const genderInfo = tags.gender ? `The user is ${tags.gender}. ` : '';
      personalContextSection = `
PERSONAL CONTEXT (tailored guidance):
${genderInfo}${summary60w}
Key priorities: ${tags.priorities?.join(', ') || 'general well-being'}
Life scores: Health ${tags.health_score}/5, Social ${tags.social_score}/5, Romance ${tags.romance_score}/5, Finance ${tags.finance_score}/5, Career ${tags.career_score}/5, Growth ${tags.growth_score}/5
`;
    }

    const systemPrompt = `You are a caring personal astrologer providing daily guidance. Your role is to generate actionable, supportive guidance based on astrological transits and the user's personal context.

${toneInstructions}

${languageInstructions}

TRANSIT INTERPRETATION:
- Carefully analyze and interpret today's planetary transits provided below
- Explain HOW each significant transit affects the user's natal chart
- Connect transit energies to practical daily experiences
- Mention specific planetary aspects (conjunctions, trines, squares, oppositions) and their meaning
- Describe the emotional and practical implications of each transit for each life area

RULES:
- No medical, financial, or legal advice - encourage professional consultation for serious issues
- Be constructive and empowering, never fatalistic or fear-inducing
- Include 2-3 practical micro-actions per section
- Keep each section guidance to 100-130 words
- Reference specific transits when explaining the energy of each area
${sensitivityMode ? '- SENSITIVITY MODE: Avoid deterministic language, anxiety-inducing phrases, or worst-case scenarios' : ''}

Your response must be valid JSON with this structure:
{
  "dailySummary": {
    "content": "100-130 words overview of today's energy with key transit interpretations",
    "mood": "One word (Transformative/Reflective/Dynamic/Harmonious/Challenging/Energetic/Peaceful)",
    "focusArea": "Most important area today based on transits"
  },
  "health": { "content": "100-130 words including transit influence on vitality", "score": 1-10, "actions": ["action1", "action2"] },
  "job": { "content": "100-130 words including transit influence on career", "score": 1-10, "actions": [...] },
  "business_money": { "content": "100-130 words including transit influence on finances", "score": 1-10, "actions": [...] },
  "love": { "content": "100-130 words including transit influence on romance", "score": 1-10, "actions": [...] },
  "partnerships": { "content": "100-130 words including transit influence on relationships", "score": 1-10, "actions": [...] },
  "personal_growth": { "content": "100-130 words including transit influence on growth", "score": 1-10, "actions": [...] }
}

`;

    // Build compact user prompt (target: 600-800 words total input)
    const userPrompt = `Generate today's guidance for ${context.userName || 'the user'}.

NATAL CHART (compact):
${this.compactNatalSummary(context.natalSummary)}

TODAY'S PLANETARY TRANSITS (interpret these carefully):
${this.compactTransits(context.transits)}

IMPORTANT: Analyze each transit above and explain its specific influence on the user's day. 
Connect the planetary energies to practical advice for each life area.
${personalContextSection}${previousDaysContext}
Generate warm, personalized guidance with detailed transit interpretations and actionable micro-recommendations for each section.`;

    try {
      const response = await this.openai.chat.completions.create({
        model: this.model,
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt },
        ],
        response_format: { type: 'json_object' },
        temperature: 0.7,
        max_tokens: 4000, // Max ~4096 for gpt-4-turbo, using 4000 to be safe
      });

      const result = JSON.parse(response.choices[0].message.content || '{}');
      
      return {
        dailySummary: result.dailySummary || { 
          content: 'Welcome to your daily guidance. The stars are aligned to support your journey today.', 
          mood: 'Balanced',
          focusArea: 'Personal Growth'
        },
        health: result.health || { content: 'Unable to generate guidance.', score: 5 },
        job: result.job || { content: 'Unable to generate guidance.', score: 5 },
        business_money: result.business_money || { content: 'Unable to generate guidance.', score: 5 },
        love: result.love || { content: 'Unable to generate guidance.', score: 5 },
        partnerships: result.partnerships || { content: 'Unable to generate guidance.', score: 5 },
        personal_growth: result.personal_growth || { content: 'Unable to generate guidance.', score: 5 },
      };
    } catch (error) {
      this.logger.error('Failed to generate daily guidance:', error.message);
      throw error;
    }
  }

  /**
   * Get the model version being used
   */
  getModelVersion(): string {
    return this.model;
  }

  /**
   * Get tone instructions based on user preference
   */
  private getToneInstructions(tone: string, sensitivityMode: boolean): string {
    const baseInstructions: Record<string, string> = {
      direct: `TONE: Be direct and practical. Focus on clear, actionable advice. Get to the point quickly. Use confident language.`,
      empathetic: `TONE: Be empathetic and reflective. Acknowledge emotions and provide gentle guidance. Use warm, supportive language. Validate their feelings.`,
      balanced: `TONE: Strike a balance between practical advice and emotional support. Be warm but focused. Offer both validation and action steps.`,
    };

    let instructions = baseInstructions[tone] || baseInstructions.balanced;

    if (sensitivityMode) {
      instructions += `\n\nSENSITIVITY: Avoid phrases like "you must", "danger", "crisis", "beware". Use gentle alternatives like "consider", "opportunity to", "you might explore". Frame challenges as growth opportunities.`;
    }

    return instructions;
  }

  /**
   * Get language-specific instructions for AI prompts
   * Supports: EN, RO, FR, DE, ES, IT, HU, PL
   */
  private getLanguageInstructions(language: Language): string {
    const instructions: Record<Language, string> = {
      EN: 'Respond entirely in English. Use professional but approachable language.',
      RO: 'IMPORTANT: Respond entirely in Romanian. Use formal but warm language. Avoid anglicisms.',
      FR: 'IMPORTANT: Respond entirely in French. Use elegant, formal language with a warm tone.',
      DE: 'IMPORTANT: Respond entirely in German. Use clear, precise language. Maintain a professional but friendly tone.',
      ES: 'IMPORTANT: Respond entirely in Spanish. Use warm, engaging language. Be expressive but professional.',
      IT: 'IMPORTANT: Respond entirely in Italian. Use expressive, warm language. Embrace emotional nuance.',
      HU: 'IMPORTANT: Respond entirely in Hungarian. Use formal but friendly language (magázódás when appropriate).',
      PL: 'IMPORTANT: Respond entirely in Polish. Use polite, formal language. Be respectful and warm.',
    };
    return instructions[language] || instructions.EN;
  }

  /**
   * Compact natal summary to ~200 words max
   */
  private compactNatalSummary(natalSummary: any): string {
    if (!natalSummary) return 'Natal chart data unavailable.';

    // If already a string, truncate if needed
    if (typeof natalSummary === 'string') {
      const words = natalSummary.split(/\s+/);
      if (words.length > 200) {
        return words.slice(0, 200).join(' ') + '...';
      }
      return natalSummary;
    }

    // Extract key elements from structured natal data
    const parts: string[] = [];

    if (natalSummary.sunSign) parts.push(`Sun: ${natalSummary.sunSign}`);
    if (natalSummary.moonSign) parts.push(`Moon: ${natalSummary.moonSign}`);
    if (natalSummary.ascendant) parts.push(`Ascendant: ${natalSummary.ascendant}`);

    // Add key planetary positions if available
    if (natalSummary.planets) {
      const keyPlanets = ['Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn'];
      for (const planet of keyPlanets) {
        if (natalSummary.planets[planet]) {
          parts.push(`${planet}: ${natalSummary.planets[planet]}`);
        }
      }
    }

    // Add summary if available
    if (natalSummary.summary && typeof natalSummary.summary === 'string') {
      parts.push(natalSummary.summary.substring(0, 300));
    }

    return parts.join('. ') || JSON.stringify(natalSummary).substring(0, 500);
  }

  /**
   * Format transits for AI interpretation
   * 
   * Prioritizes the most impactful transits and formats them clearly:
   * - Personal planets (Sun, Moon, Mercury, Venus, Mars) aspects are most relevant for daily guidance
   * - Includes house placement for context
   * - Shows timing context (is the aspect exact today, building, or fading?)
   */
  private compactTransits(transits: any[]): string {
    if (!transits || transits.length === 0) {
      return 'No significant transits today.';
    }

    // Prioritize transits by significance
    // Personal planet transits are more impactful for daily guidance
    const personalPlanets = ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars'];
    const prioritized = [...transits].sort((a, b) => {
      const aScore = personalPlanets.includes(a.transitPlanet) ? 2 : 0;
      const bScore = personalPlanets.includes(b.transitPlanet) ? 2 : 0;
      return bScore - aScore;
    });

    // Take top 10 transits (more context = better interpretation)
    const significantTransits = prioritized.slice(0, 10);

    return significantTransits
      .map((t) => {
        if (typeof t === 'string') return t;
        
        // New format from parseTransits
        if (t.transitPlanet && t.aspectType && t.natalPlanet) {
          let desc = `${t.transitPlanet} ${t.aspectType} natal ${t.natalPlanet}`;
          
          // Add sign and house context
          if (t.transitSign) desc += ` (transit in ${t.transitSign}`;
          if (t.natalHouse) desc += `, natal House ${t.natalHouse}`;
          if (t.transitSign || t.natalHouse) desc += ')';
          
          // Add retrograde indicator
          if (t.isRetrograde) desc += ' [Rx]';
          
          // Add timing context
          if (t.exactTime && t.exactTime !== '-') {
            const exactDate = new Date(t.exactTime);
            const today = new Date();
            const diffDays = Math.round((exactDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
            if (diffDays === 0) desc += ' - EXACT TODAY';
            else if (diffDays > 0 && diffDays <= 2) desc += ' - building';
            else if (diffDays < 0 && diffDays >= -2) desc += ' - fading';
          }
          
          return desc;
        }
        
        // Legacy formats
        if (t.aspect && t.planet1 && t.planet2) {
          return `${t.planet1} ${t.aspect} ${t.planet2}${t.orb ? ` (${t.orb}°)` : ''}`;
        }
        if (t.description) return t.description.substring(0, 100);
        return JSON.stringify(t).substring(0, 80);
      })
      .join('\n');  // Use newlines for better readability
  }

  /**
   * Generate plain text response from a prompt (for natal chart interpretations)
   */
  async generateText(systemPromptOrPrompt: string, userPrompt?: string): Promise<string> {
    try {
      // Support both single prompt and system+user prompt variants
      const messages = userPrompt
        ? [
            { role: 'system' as const, content: systemPromptOrPrompt },
            { role: 'user' as const, content: userPrompt },
          ]
        : [{ role: 'user' as const, content: systemPromptOrPrompt }];

      const response = await this.openai.chat.completions.create({
        model: this.model,
        messages,
        temperature: 0.7,
        max_tokens: userPrompt ? 4000 : 500, // More tokens for structured requests
      });

      return response.choices[0].message.content || '';
    } catch (error) {
      this.logger.error('Failed to generate text:', error.message);
      throw error;
    }
  }
}

