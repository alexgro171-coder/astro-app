import { IsNotEmpty, IsString, IsOptional, MaxLength } from 'class-validator';

export class AskGuideQuestionDto {
  @IsNotEmpty()
  @IsString()
  @MaxLength(2000, { message: 'Question must be less than 2000 characters' })
  question: string;

  @IsOptional()
  @IsString()
  locale?: string;
}

export class AskGuideUsageResponseDto {
  requestCount: number;
  limitCount: number;
  remaining: number;
  hasAddon: boolean;
  billingMonthEnd: string;
  canRequest: boolean;
}

export class AskGuideRequestResponseDto {
  id: string;
  question: string;
  answer?: string;
  status: 'PENDING' | 'READY' | 'FAILED';
  errorMsg?: string;
  createdAt: string;
}

export class AskGuideHistoryResponseDto {
  requests: AskGuideRequestResponseDto[];
  usage: AskGuideUsageResponseDto;
}
