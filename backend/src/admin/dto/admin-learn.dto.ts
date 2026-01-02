import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsOptional, IsEnum } from 'class-validator';
import { ArticleStatus, LearnCategory, Language } from '@prisma/client';

export class UploadResultDto {
  @ApiProperty()
  success: boolean;

  @ApiProperty()
  category: string;

  @ApiProperty()
  locale: string;

  @ApiProperty()
  slug: string;

  @ApiProperty()
  title: string;

  @ApiProperty()
  isUpdate: boolean;
}

export class BulkUploadResultDto {
  @ApiProperty({ type: [UploadResultDto] })
  successes: UploadResultDto[];

  @ApiProperty({ type: [String] })
  failures: string[];
}

export class ArticleListItemDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ enum: LearnCategory })
  category: LearnCategory;

  @ApiProperty({ enum: Language })
  locale: Language;

  @ApiProperty()
  slug: string;

  @ApiProperty()
  title: string;

  @ApiProperty({ enum: ArticleStatus })
  status: ArticleStatus;

  @ApiProperty()
  updatedAt: Date;
}

export class UpdateArticleDto {
  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  title?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  content?: string;

  @ApiPropertyOptional({ enum: ArticleStatus })
  @IsEnum(ArticleStatus)
  @IsOptional()
  status?: ArticleStatus;
}

export class ArticleListQueryDto {
  @ApiPropertyOptional({ enum: LearnCategory })
  @IsEnum(LearnCategory)
  @IsOptional()
  category?: LearnCategory;

  @ApiPropertyOptional({ enum: Language })
  @IsEnum(Language)
  @IsOptional()
  locale?: Language;

  @ApiPropertyOptional({ enum: ArticleStatus })
  @IsEnum(ArticleStatus)
  @IsOptional()
  status?: ArticleStatus;
}

