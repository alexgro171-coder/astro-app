import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';
import { ConcernCategory, Language } from '@prisma/client';

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
  concernText?: string;
}

interface GuidanceContext {
  natalSummary: any;
  transits: any[];
  activeConcern?: {
    category: ConcernCategory;
    text: string;
  };
  previousDays?: PreviousDayData[];
  language: Language;
  userName?: string;
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
    this.model = this.configService.get<string>('OPENAI_MODEL', 'gpt-4-turbo-preview');
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
   */
  async generateDailyGuidance(context: GuidanceContext): Promise<GuidanceSections> {
    const languageInstructions = context.language === 'RO' 
      ? 'Respond entirely in Romanian. Use formal but warm language.'
      : 'Respond entirely in English. Use professional but approachable language.';

    // Build previous days context for continuity
    let previousDaysContext = '';
    if (context.previousDays && context.previousDays.length > 0) {
      previousDaysContext = `
PREVIOUS DAYS EVOLUTION (for context and continuity):
${context.previousDays.map(day => `
- ${day.date}: Health ${day.scores.health}/10, Career ${day.scores.job}/10, Money ${day.scores.business_money}/10, Love ${day.scores.love}/10, Partnerships ${day.scores.partnerships}/10, Growth ${day.scores.personal_growth}/10
  ${day.concernText ? `Focus was on: "${day.concernText}"` : ''}
`).join('')}

Use this history to:
1. Reference improvements or changes ("Yesterday's energy was challenging, but today...")
2. Show awareness of their journey ("Over the past days, I've noticed...")
3. Create narrative continuity ("Building on yesterday's focus on...")
`;
    }

    const systemPrompt = `You are a caring personal astrologer who has been accompanying this user on their daily journey. You know their chart intimately and track their progress day by day.

Your approach:
- Be personal and warm - you're a trusted guide, not a generic horoscope
- Reference previous days when relevant to show you're paying attention
- Be constructive and empowering, never fatalistic
- Offer practical, actionable advice
- Connect astrological influences to real-life situations
- When there's an active concern, weave it into your overall narrative

${languageInstructions}

You will receive:
1. The user's natal chart summary
2. Today's transits
3. An active concern (if any)
4. Previous days' scores and concerns (if available)

Your response must be a JSON object with:

1. "dailySummary": A personalized overview containing:
   - "content": 2-3 paragraphs summarizing today's energy. Start with a warm greeting using their name if available. Reference their concern and how today's transits affect it. Mention trends from previous days if available. End with an encouraging insight.
   - "mood": One word describing today's overall energy (e.g., "Transformative", "Reflective", "Dynamic", "Harmonious", "Challenging")
   - "focusArea": The most important area to focus on today

2. Six sections with "content" (2-3 paragraphs) and "score" (1-10):
   - "health", "job", "business_money", "love", "partnerships", "personal_growth"

Example structure:
{
  "dailySummary": {
    "content": "Good morning, [Name]! Today's cosmic weather brings...",
    "mood": "Transformative",
    "focusArea": "Personal Growth"
  },
  "health": { "content": "...", "score": 7 },
  ...
}

${context.activeConcern ? `
IMPORTANT: The user has shared this concern: "${context.activeConcern.text}"
This is in the ${context.activeConcern.category} area. Make this the central theme of your daily summary and give it extra attention in the relevant section.` : ''}`;

    const userPrompt = `Generate today's personalized guidance for ${context.userName || 'the user'}.

NATAL CHART SUMMARY:
${JSON.stringify(context.natalSummary, null, 2)}

TODAY'S TRANSITS:
${JSON.stringify(context.transits, null, 2)}

${context.activeConcern ? `ACTIVE CONCERN (${context.activeConcern.category}):
"${context.activeConcern.text}"` : 'No specific concern at this time.'}
${previousDaysContext}

Generate a warm, personalized daily guidance that makes them feel accompanied on their journey.`;

    try {
      const response = await this.openai.chat.completions.create({
        model: this.model,
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt },
        ],
        response_format: { type: 'json_object' },
        temperature: 0.7,
        max_tokens: 4000,
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
}

