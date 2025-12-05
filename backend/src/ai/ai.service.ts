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
  health: { content: string; score: number };
  job: { content: string; score: number };
  business_money: { content: string; score: number };
  love: { content: string; score: number };
  partnerships: { content: string; score: number };
  personal_growth: { content: string; score: number };
}

interface GuidanceContext {
  natalSummary: any;
  transits: any[];
  activeConcern?: {
    category: ConcernCategory;
    text: string;
  };
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

    const systemPrompt = `You are a professional Western astrologer and life coach. You provide daily guidance based on astrological data.

Your approach:
- Be constructive and empowering, never fatalistic
- Offer practical, actionable advice
- Connect astrological influences to real-life situations
- Be specific about the energies at play without being deterministic
- Acknowledge challenges while focusing on opportunities

${languageInstructions}

You will receive:
1. A summary of the user's natal chart (planetary positions)
2. Today's transits (aspects between transiting planets and natal planets)
3. Optionally, an active concern the user is focused on

Your response must be a JSON object with these sections, each containing "content" (2-3 paragraphs of guidance) and "score" (1-10, where 10 is most favorable):

{
  "health": { "content": "...", "score": 7 },
  "job": { "content": "...", "score": 8 },
  "business_money": { "content": "...", "score": 6 },
  "love": { "content": "...", "score": 5 },
  "partnerships": { "content": "...", "score": 7 },
  "personal_growth": { "content": "...", "score": 9 }
}

${context.activeConcern ? `IMPORTANT: The user has an active concern in the ${context.activeConcern.category} area. Give extra attention and specific guidance for this topic.` : ''}`;

    const userPrompt = `Generate today's guidance for ${context.userName || 'the user'}.

NATAL CHART SUMMARY:
${JSON.stringify(context.natalSummary, null, 2)}

TODAY'S TRANSITS:
${JSON.stringify(context.transits, null, 2)}

${context.activeConcern ? `ACTIVE CONCERN (${context.activeConcern.category}):
"${context.activeConcern.text}"` : 'No specific concern at this time.'}

Generate comprehensive daily guidance for each life area.`;

    try {
      const response = await this.openai.chat.completions.create({
        model: this.model,
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt },
        ],
        response_format: { type: 'json_object' },
        temperature: 0.7,
        max_tokens: 3000,
      });

      const result = JSON.parse(response.choices[0].message.content || '{}');
      
      return {
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

