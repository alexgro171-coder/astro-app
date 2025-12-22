import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsString, IsOptional, ValidateNested, IsEnum } from 'class-validator';
import { Type } from 'class-transformer';

/**
 * Onboarding Questions Configuration
 * 
 * These questions are used to personalize the AI guidance for Premium users.
 * Standard users' answers are stored but NOT used in AI prompts.
 */
export const ONBOARDING_QUESTIONS = [
  {
    id: 'relationship_status',
    question: 'What is your current relationship status?',
    type: 'single_choice',
    options: ['Single', 'In a relationship', 'Married', 'Divorced/Separated', 'Prefer not to say'],
    category: 'relationships',
  },
  {
    id: 'career_situation',
    question: 'How would you describe your current career situation?',
    type: 'single_choice',
    options: ['Student', 'Employed', 'Self-employed/Entrepreneur', 'Unemployed/Seeking', 'Retired', 'Other'],
    category: 'career',
  },
  {
    id: 'main_life_focus',
    question: 'What areas of life are you most focused on improving right now?',
    type: 'multiple_choice',
    options: ['Career/Work', 'Love/Relationships', 'Health/Wellness', 'Financial stability', 'Personal growth', 'Family', 'Spirituality'],
    category: 'general',
  },
  {
    id: 'stress_level',
    question: 'How would you rate your current stress level?',
    type: 'single_choice',
    options: ['Very low', 'Low', 'Moderate', 'High', 'Very high'],
    category: 'health',
  },
  {
    id: 'guidance_tone',
    question: 'What tone do you prefer for your daily guidance?',
    type: 'single_choice',
    options: ['Direct and practical', 'Supportive and encouraging', 'Spiritual and reflective', 'Balanced mix'],
    category: 'preferences',
  },
  {
    id: 'current_challenge',
    question: 'Is there a specific challenge or decision you\'re currently facing?',
    type: 'text',
    placeholder: 'Optional - Share what\'s on your mind...',
    category: 'personal',
  },
  {
    id: 'astrology_experience',
    question: 'How familiar are you with astrology?',
    type: 'single_choice',
    options: ['Complete beginner', 'Know my Sun sign', 'Intermediate knowledge', 'Advanced/Very familiar'],
    category: 'preferences',
  },
];

export class QuestionAnswerDto {
  @ApiProperty({ description: 'Question ID', example: 'relationship_status' })
  @IsString()
  questionId: string;

  @ApiProperty({ 
    description: 'Answer (string for single choice/text, array for multiple choice)',
    example: 'In a relationship',
  })
  answer: string | string[];
}

export class SaveContextAnswersDto {
  @ApiProperty({
    description: 'Array of question answers',
    type: [QuestionAnswerDto],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => QuestionAnswerDto)
  answers: QuestionAnswerDto[];

  @ApiProperty({
    description: 'Preferred tone for guidance',
    enum: ['supportive', 'direct', 'spiritual', 'balanced'],
    required: false,
  })
  @IsOptional()
  @IsEnum(['supportive', 'direct', 'spiritual', 'balanced'])
  preferredTone?: string;

  @ApiProperty({
    description: 'Priority life areas',
    type: [String],
    required: false,
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  priorityAreas?: string[];
}

export class ContextQuestionsResponseDto {
  @ApiProperty({ description: 'List of onboarding questions' })
  questions: typeof ONBOARDING_QUESTIONS;

  @ApiProperty({ description: 'Whether user has already completed context profile' })
  completed: boolean;

  @ApiProperty({ description: 'Existing answers if any', required: false })
  existingAnswers?: Record<string, any>;
}

