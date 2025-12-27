import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsOptional,
  IsBoolean,
  IsNumber,
  IsArray,
  ValidateNested,
  Min,
  Max,
  ArrayMaxSize,
  IsIn,
  IsEnum,
} from 'class-validator';
import { Type } from 'class-transformer';

// ============================================
// SECTION A: Relationships & Family
// ============================================

export enum RelationshipStatus {
  SINGLE = 'single',
  IN_RELATIONSHIP = 'in_relationship',
  MARRIED = 'married',
  SEPARATED = 'separated',
  WIDOWED = 'widowed',
  PREFER_NOT_TO_SAY = 'prefer_not_to_say',
}

export enum ChildGender {
  MALE = 'M',
  FEMALE = 'F',
  PREFER_NOT_TO_SAY = 'prefer_not_to_say',
}

export class ChildInfoDto {
  @ApiProperty({ description: 'Child age (0-30)', minimum: 0, maximum: 30 })
  @IsNumber()
  @Min(0)
  @Max(30)
  age: number;

  @ApiProperty({ enum: ChildGender, description: 'Child gender' })
  @IsEnum(ChildGender)
  gender: ChildGender;
}

// ============================================
// SECTION B: Professional Life
// ============================================

export enum WorkStatus {
  STUDENT = 'student',
  UNEMPLOYED = 'unemployed',
  EMPLOYED_IC = 'employed_ic', // Individual contributor
  EMPLOYED_MANAGEMENT = 'employed_management',
  EXECUTIVE = 'executive', // C-level / Director
  SELF_EMPLOYED = 'self_employed',
  ENTREPRENEUR = 'entrepreneur',
  INVESTOR = 'investor',
  RETIRED = 'retired',
  HOMEMAKER = 'homemaker',
  CAREER_BREAK = 'career_break',
  OTHER = 'other',
}

export enum Industry {
  TECH_IT = 'tech_it',
  FINANCE = 'finance',
  HEALTHCARE = 'healthcare',
  EDUCATION = 'education',
  SALES_MARKETING = 'sales_marketing',
  REAL_ESTATE = 'real_estate',
  HOSPITALITY = 'hospitality',
  GOVERNMENT = 'government',
  CREATIVE = 'creative',
  OTHER = 'other',
}

// ============================================
// SECTION C: Self-Assessment (Likert 1-5)
// ============================================

// Scores 1-5 are directly in the main DTO

// ============================================
// SECTION D: Priorities & Tone
// ============================================

export enum Priority {
  HEALTH_HABITS = 'health_habits',
  CAREER_GROWTH = 'career_growth',
  BUSINESS_DECISIONS = 'business_decisions',
  MONEY_STABILITY = 'money_stability',
  LOVE_RELATIONSHIP = 'love_relationship',
  FAMILY_PARENTING = 'family_parenting',
  SOCIAL_LIFE = 'social_life',
  PERSONAL_GROWTH = 'personal_growth',
}

export enum GuidanceStyle {
  DIRECT = 'direct', // Directă și practică
  EMPATHETIC = 'empathetic', // Empatică și reflectivă
  BALANCED = 'balanced', // Echilibrată
}

// ============================================
// MAIN DTO
// ============================================

export class ContextAnswersDto {
  // Section A: Relationships & Family
  @ApiProperty({ enum: RelationshipStatus, description: 'Current relationship status' })
  @IsEnum(RelationshipStatus)
  relationshipStatus: RelationshipStatus;

  @ApiPropertyOptional({
    description: 'Are you looking for a relationship? (only if single/separated/widowed)',
  })
  @IsOptional()
  @IsBoolean()
  seekingRelationship?: boolean;

  @ApiProperty({ description: 'Do you have children?' })
  @IsBoolean()
  hasChildren: boolean;

  @ApiPropertyOptional({ type: [ChildInfoDto], description: 'Children info (if hasChildren = true)' })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ChildInfoDto)
  children?: ChildInfoDto[];

  // Section B: Professional Life
  @ApiProperty({ enum: WorkStatus, description: 'Current work status' })
  @IsEnum(WorkStatus)
  workStatus: WorkStatus;

  @ApiPropertyOptional({ description: 'Custom work status (if OTHER selected)' })
  @IsOptional()
  @IsString()
  workStatusOther?: string;

  @ApiPropertyOptional({ enum: Industry, description: 'Main industry/domain' })
  @IsOptional()
  @IsEnum(Industry)
  industry?: Industry;

  // Section C: Self-Assessment (Likert 1-5)
  @ApiProperty({ description: 'Health & energy score (1=issues, 5=excellent)', minimum: 1, maximum: 5 })
  @IsNumber()
  @Min(1)
  @Max(5)
  healthScore: number;

  @ApiProperty({ description: 'Social life score (1=isolated, 5=thriving)', minimum: 1, maximum: 5 })
  @IsNumber()
  @Min(1)
  @Max(5)
  socialScore: number;

  @ApiProperty({ description: 'Romantic life score (1=absent/toxic, 5=fulfilled)', minimum: 1, maximum: 5 })
  @IsNumber()
  @Min(1)
  @Max(5)
  romanceScore: number;

  @ApiProperty({ description: 'Financial stability score (1=hardship, 5=excellent)', minimum: 1, maximum: 5 })
  @IsNumber()
  @Min(1)
  @Max(5)
  financeScore: number;

  @ApiProperty({ description: 'Career satisfaction score (1=stuck, 5=progress)', minimum: 1, maximum: 5 })
  @IsNumber()
  @Min(1)
  @Max(5)
  careerScore: number;

  @ApiProperty({ description: 'Personal growth interest (1=low, 5=very high)', minimum: 1, maximum: 5 })
  @IsNumber()
  @Min(1)
  @Max(5)
  growthScore: number;

  // Section D: Priorities & Tone
  @ApiProperty({
    enum: Priority,
    isArray: true,
    description: 'Priority areas (max 2)',
    maxItems: 2,
  })
  @IsArray()
  @ArrayMaxSize(2)
  @IsEnum(Priority, { each: true })
  priorities: Priority[];

  @ApiProperty({ enum: GuidanceStyle, description: 'Preferred guidance style' })
  @IsEnum(GuidanceStyle)
  guidanceStyle: GuidanceStyle;

  @ApiPropertyOptional({
    description: 'Sensitivity mode - avoid deterministic/anxiety-inducing phrasing',
  })
  @IsOptional()
  @IsBoolean()
  sensitivityMode?: boolean;
}

// ============================================
// RESPONSE DTOs
// ============================================

export class ContextProfileResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  version: number;

  @ApiProperty({ type: ContextAnswersDto })
  answers: ContextAnswersDto;

  @ApiProperty({ description: 'AI-generated summary (max 60 words)' })
  summary60w: string;

  @ApiProperty({ description: 'Structured tags for quick access' })
  summaryTags: Record<string, any>;

  @ApiProperty({ description: 'Next review date (90 days from creation/update)' })
  nextReviewAt: Date;

  @ApiProperty()
  completedAt: Date;
}

export class ContextStatusResponseDto {
  @ApiProperty()
  hasProfile: boolean;

  @ApiProperty()
  needsReview: boolean;

  @ApiPropertyOptional()
  nextReviewAt?: Date;

  @ApiPropertyOptional()
  currentVersion?: number;
}

