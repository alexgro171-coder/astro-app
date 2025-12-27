import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';
import {
  ContextAnswersDto,
  RelationshipStatus,
  WorkStatus,
  GuidanceStyle,
  Priority,
} from './dto/context-answers.dto';

/**
 * Context Summary structure returned by AI
 */
export interface ContextSummaryResult {
  summary60w: string;
  tags: ContextTags;
}

/**
 * Structured tags for quick access in prompts
 */
export interface ContextTags {
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
}

/**
 * ContextSummarizerService
 *
 * Uses OpenAI to generate a concise 60-word summary and structured tags
 * from the user's questionnaire answers.
 */
@Injectable()
export class ContextSummarizerService {
  private readonly logger = new Logger(ContextSummarizerService.name);
  private readonly openai: OpenAI;
  private readonly model: string;

  constructor(private configService: ConfigService) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
    this.model = this.configService.get<string>('OPENAI_MODEL', 'gpt-4-turbo-preview');
  }

  /**
   * Generate context summary and tags from answers
   *
   * @param answers - Structured questionnaire answers
   * @returns Summary (max 60 words) and structured tags
   */
  async generateSummary(answers: ContextAnswersDto): Promise<ContextSummaryResult> {
    const systemPrompt = `You are a concise profile summarizer for an astrology guidance app.
Your task is to transform structured questionnaire answers into:
1. A neutral, factual summary of max 60 words (summary_60w)
2. Structured tags for quick reference

Rules:
- Do not include predictions or advice
- Do not exceed 60 words in summary_60w (critical!)
- Be neutral, factual, non-judgmental
- Do not include names or personal identifiers
- Use third person ("The user is..." or just describe facts)
- Output must be valid JSON only
- If fields are missing, set to null/unknown

Output Format (strict JSON):
{
  "summary_60w": "...max 60 words in English...",
  "tags": {
    "relationship_status": "...",
    "seeking_relationship": true/false/null,
    "has_children": true/false,
    "children_count": 0..n,
    "work_status": "...",
    "industry": "...|null",
    "health_score": 1..5,
    "social_score": 1..5,
    "romance_score": 1..5,
    "finance_score": 1..5,
    "career_score": 1..5,
    "growth_score": 1..5,
    "priorities": ["...max 2..."],
    "tone_preference": "direct|empathetic|balanced",
    "sensitivity_mode": true/false
  }
}`;

    const userPrompt = `Transform these questionnaire answers into the required JSON format.
Ensure summary_60w is maximum 60 words.

Questionnaire Answers:
${JSON.stringify(answers, null, 2)}

Generate the JSON output now.`;

    try {
      const response = await this.openai.chat.completions.create({
        model: this.model,
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt },
        ],
        response_format: { type: 'json_object' },
        temperature: 0.3,
        max_tokens: 500,
      });

      const result = JSON.parse(response.choices[0].message.content || '{}');

      // Validate and enforce constraints
      const summary60w = this.enforceSummaryLimit(result.summary_60w || '', 60);
      const tags = this.validateTags(result.tags || {}, answers);

      this.logger.log(
        `Generated context summary (${summary60w.split(' ').length} words)`,
      );

      return {
        summary60w,
        tags,
      };
    } catch (error) {
      this.logger.error('Failed to generate context summary:', error.message);

      // Fallback: generate basic summary without AI
      return this.generateFallbackSummary(answers);
    }
  }

  /**
   * Enforce maximum word limit on summary
   */
  private enforceSummaryLimit(summary: string, maxWords: number): string {
    const words = summary.trim().split(/\s+/);
    if (words.length <= maxWords) {
      return summary;
    }

    // Truncate and add ellipsis
    return words.slice(0, maxWords - 1).join(' ') + '...';
  }

  /**
   * Validate and normalize tags, ensuring constraints
   */
  private validateTags(
    tags: Partial<ContextTags>,
    answers: ContextAnswersDto,
  ): ContextTags {
    return {
      relationship_status: tags.relationship_status || answers.relationshipStatus,
      seeking_relationship:
        tags.seeking_relationship !== undefined
          ? tags.seeking_relationship
          : answers.seekingRelationship ?? null,
      has_children: tags.has_children ?? answers.hasChildren,
      children_count:
        tags.children_count ?? (answers.children?.length || 0),
      work_status: tags.work_status || answers.workStatus,
      industry: tags.industry || answers.industry || null,
      health_score: tags.health_score ?? answers.healthScore,
      social_score: tags.social_score ?? answers.socialScore,
      romance_score: tags.romance_score ?? answers.romanceScore,
      finance_score: tags.finance_score ?? answers.financeScore,
      career_score: tags.career_score ?? answers.careerScore,
      growth_score: tags.growth_score ?? answers.growthScore,
      // Enforce max 2 priorities
      priorities: (tags.priorities || answers.priorities || []).slice(0, 2),
      tone_preference: this.mapTonePreference(
        tags.tone_preference || answers.guidanceStyle,
      ),
      sensitivity_mode: tags.sensitivity_mode ?? answers.sensitivityMode ?? false,
    };
  }

  /**
   * Map guidance style to tone preference
   */
  private mapTonePreference(
    style: string,
  ): 'direct' | 'empathetic' | 'balanced' {
    switch (style) {
      case 'direct':
      case GuidanceStyle.DIRECT:
        return 'direct';
      case 'empathetic':
      case GuidanceStyle.EMPATHETIC:
        return 'empathetic';
      default:
        return 'balanced';
    }
  }

  /**
   * Generate fallback summary without AI
   */
  private generateFallbackSummary(
    answers: ContextAnswersDto,
  ): ContextSummaryResult {
    const parts: string[] = [];

    // Relationship
    const relMap: Record<RelationshipStatus, string> = {
      [RelationshipStatus.SINGLE]: 'Single',
      [RelationshipStatus.IN_RELATIONSHIP]: 'In a relationship',
      [RelationshipStatus.MARRIED]: 'Married',
      [RelationshipStatus.SEPARATED]: 'Separated/divorced',
      [RelationshipStatus.WIDOWED]: 'Widowed',
      [RelationshipStatus.PREFER_NOT_TO_SAY]: '',
    };
    if (relMap[answers.relationshipStatus]) {
      parts.push(relMap[answers.relationshipStatus]);
    }

    // Children
    if (answers.hasChildren && answers.children?.length) {
      parts.push(`${answers.children.length} child(ren)`);
    }

    // Work
    const workMap: Partial<Record<WorkStatus, string>> = {
      [WorkStatus.STUDENT]: 'Student',
      [WorkStatus.EMPLOYED_IC]: 'Employed',
      [WorkStatus.EMPLOYED_MANAGEMENT]: 'In management',
      [WorkStatus.EXECUTIVE]: 'Executive',
      [WorkStatus.SELF_EMPLOYED]: 'Self-employed',
      [WorkStatus.ENTREPRENEUR]: 'Entrepreneur',
    };
    if (workMap[answers.workStatus]) {
      parts.push(workMap[answers.workStatus]);
    }

    // Scores summary
    const avgScore = Math.round(
      (answers.healthScore +
        answers.socialScore +
        answers.romanceScore +
        answers.financeScore +
        answers.careerScore +
        answers.growthScore) /
        6,
    );
    parts.push(`Overall life satisfaction: ${avgScore}/5`);

    // Priorities
    if (answers.priorities.length > 0) {
      const priorityMap: Record<Priority, string> = {
        [Priority.HEALTH_HABITS]: 'health',
        [Priority.CAREER_GROWTH]: 'career',
        [Priority.BUSINESS_DECISIONS]: 'business',
        [Priority.MONEY_STABILITY]: 'finances',
        [Priority.LOVE_RELATIONSHIP]: 'love',
        [Priority.FAMILY_PARENTING]: 'family',
        [Priority.SOCIAL_LIFE]: 'social life',
        [Priority.PERSONAL_GROWTH]: 'growth',
      };
      const priorityNames = answers.priorities.map((p) => priorityMap[p]);
      parts.push(`Focusing on ${priorityNames.join(' and ')}`);
    }

    return {
      summary60w: parts.join('. ') + '.',
      tags: this.validateTags({}, answers),
    };
  }

  /**
   * Get token estimate for context (for prompt budgeting)
   */
  estimateTokens(summary: string): number {
    // Rough estimate: ~1.3 tokens per word
    return Math.ceil(summary.split(/\s+/).length * 1.3);
  }
}

