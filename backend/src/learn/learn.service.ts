import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AnalyticsService } from '../analytics/analytics.service';
import { LearnCategory, Language, ArticleStatus } from '@prisma/client';
import { LearnItemsResponseDto, LearnArticleDto } from './dto/learn.dto';

@Injectable()
export class LearnService {
  private readonly logger = new Logger(LearnService.name);

  constructor(
    private prisma: PrismaService,
    private analytics: AnalyticsService,
  ) {}

  /**
   * Get list of published articles for a category and locale
   * Falls back to EN if no articles found for requested locale
   */
  async getItems(
    category: LearnCategory,
    locale: Language,
  ): Promise<LearnItemsResponseDto> {
    // Try requested locale first
    let articles = await this.prisma.learnArticle.findMany({
      where: {
        category,
        locale,
        status: ArticleStatus.PUBLISHED,
      },
      select: {
        slug: true,
        title: true,
        updatedAt: true,
      },
      orderBy: { title: 'asc' },
    });

    let fallbackLocale: string | undefined;

    // If no articles found and locale is not EN, fall back to EN
    if (articles.length === 0 && locale !== Language.EN) {
      articles = await this.prisma.learnArticle.findMany({
        where: {
          category,
          locale: Language.EN,
          status: ArticleStatus.PUBLISHED,
        },
        select: {
          slug: true,
          title: true,
          updatedAt: true,
        },
        orderBy: { title: 'asc' },
      });
      
      if (articles.length > 0) {
        fallbackLocale = 'EN';
      }
    }

    return {
      items: articles,
      fallbackLocale,
    };
  }

  /**
   * Get a single published article by category, locale, and slug
   * Falls back to EN if not found in requested locale
   */
  async getArticle(
    category: LearnCategory,
    locale: Language,
    slug: string,
    userId?: string,
  ): Promise<LearnArticleDto> {
    // Try requested locale first
    let article = await this.prisma.learnArticle.findFirst({
      where: {
        category,
        locale,
        slug: slug.toLowerCase(),
        status: ArticleStatus.PUBLISHED,
      },
    });

    let localeUsed = locale;

    // If not found and locale is not EN, try EN
    if (!article && locale !== Language.EN) {
      article = await this.prisma.learnArticle.findFirst({
        where: {
          category,
          locale: Language.EN,
          slug: slug.toLowerCase(),
          status: ArticleStatus.PUBLISHED,
        },
      });
      
      if (article) {
        localeUsed = Language.EN;
      }
    }

    if (!article) {
      throw new NotFoundException(`Article not found: ${category}/${locale}/${slug}`);
    }

    // Log analytics event
    await this.analytics.logEvent('LEARN_ARTICLE_OPENED', userId, {
      category,
      localeRequested: locale,
      localeUsed,
      slug,
    });

    return {
      title: article.title,
      content: article.content,
      updatedAt: article.updatedAt,
      localeUsed,
    };
  }

  /**
   * Log that user opened the Learn section
   */
  async logLearnOpened(userId?: string): Promise<void> {
    await this.analytics.logEvent('LEARN_OPENED', userId);
  }
}

