import { ApiProperty } from '@nestjs/swagger';

export class LearnItemDto {
  @ApiProperty()
  slug: string;

  @ApiProperty()
  title: string;

  @ApiProperty()
  updatedAt: Date;
}

export class LearnItemsResponseDto {
  @ApiProperty({ type: [LearnItemDto] })
  items: LearnItemDto[];

  @ApiProperty({ required: false })
  fallbackLocale?: string;
}

export class LearnArticleDto {
  @ApiProperty()
  title: string;

  @ApiProperty()
  content: string;

  @ApiProperty()
  updatedAt: Date;

  @ApiProperty()
  localeUsed: string;
}

