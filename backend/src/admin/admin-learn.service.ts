import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { LearnCategory, Language, ArticleStatus } from '@prisma/client';
import {
  UploadResultDto,
  BulkUploadResultDto,
  ArticleListItemDto,
  UpdateArticleDto,
  ArticleListQueryDto,
} from './dto/admin-learn.dto';
import * as AdmZip from 'adm-zip';

interface ParsedFilename {
  category: LearnCategory;
  locale: Language;
  slug: string;
}

@Injectable()
export class AdminLearnService {
  private readonly logger = new Logger(AdminLearnService.name);

  constructor(private prisma: PrismaService) {}

  /**
   * Parse filename like PLANETS_en_sun.md or SIGNS_RO_aries.txt
   */
  parseFilename(filename: string): ParsedFilename | null {
    // Remove extension
    const nameWithoutExt = filename.replace(/\.(md|txt)$/i, '');
    const parts = nameWithoutExt.split('_');

    if (parts.length < 3) {
      return null;
    }

    const [categoryStr, localeStr, ...slugParts] = parts;
    const slug = slugParts.join('_').toLowerCase();

    // Validate category
    const category = categoryStr.toUpperCase();
    if (!Object.values(LearnCategory).includes(category as LearnCategory)) {
      return null;
    }

    // Validate locale
    const locale = localeStr.toUpperCase();
    if (!Object.values(Language).includes(locale as Language)) {
      return null;
    }

    return {
      category: category as LearnCategory,
      locale: locale as Language,
      slug,
    };
  }

  /**
   * Extract title from content or generate from slug
   */
  extractTitle(content: string, slug: string): string {
    const lines = content.trim().split('\n');
    const firstLine = lines[0]?.trim();

    // If starts with markdown heading, use it as title
    if (firstLine?.startsWith('# ')) {
      return firstLine.substring(2).trim();
    }

    // Otherwise capitalize slug
    return slug
      .split('-')
      .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' ');
  }

  /**
   * Remove title line from content if present
   */
  cleanContent(content: string): string {
    const lines = content.trim().split('\n');
    if (lines[0]?.trim().startsWith('# ')) {
      return lines.slice(1).join('\n').trim();
    }
    return content.trim();
  }

  /**
   * Upload a single file
   */
  async uploadFile(
    filename: string,
    content: string,
  ): Promise<UploadResultDto> {
    const parsed = this.parseFilename(filename);

    if (!parsed) {
      throw new BadRequestException(
        `Invalid filename format: ${filename}. Expected: CATEGORY_locale_slug.md or .txt`,
      );
    }

    const { category, locale, slug } = parsed;
    const title = this.extractTitle(content, slug);
    const cleanedContent = this.cleanContent(content);

    // Check if article exists
    const existing = await this.prisma.learnArticle.findUnique({
      where: {
        category_locale_slug: { category, locale, slug },
      },
    });

    if (existing) {
      // Update existing article (keep status)
      await this.prisma.learnArticle.update({
        where: { id: existing.id },
        data: {
          title,
          content: cleanedContent,
        },
      });

      this.logger.log(`Updated article: ${category}/${locale}/${slug}`);

      return {
        success: true,
        category,
        locale,
        slug,
        title,
        isUpdate: true,
      };
    } else {
      // Create new article as DRAFT
      await this.prisma.learnArticle.create({
        data: {
          category,
          locale,
          slug,
          title,
          content: cleanedContent,
          status: ArticleStatus.DRAFT,
        },
      });

      this.logger.log(`Created article: ${category}/${locale}/${slug}`);

      return {
        success: true,
        category,
        locale,
        slug,
        title,
        isUpdate: false,
      };
    }
  }

  /**
   * Upload a ZIP file with multiple articles
   */
  async uploadZip(buffer: Buffer): Promise<BulkUploadResultDto> {
    const zip = new AdmZip(buffer);
    const entries = zip.getEntries();

    const successes: UploadResultDto[] = [];
    const failures: string[] = [];

    for (const entry of entries) {
      const filename = entry.entryName;

      // Skip directories and hidden files
      if (entry.isDirectory || filename.startsWith('.') || filename.includes('__MACOSX')) {
        continue;
      }

      // Only process .md and .txt files
      if (!filename.match(/\.(md|txt)$/i)) {
        continue;
      }

      // Get just the filename (not path)
      const basename = filename.split('/').pop() || filename;

      try {
        const content = entry.getData().toString('utf8');
        const result = await this.uploadFile(basename, content);
        successes.push(result);
      } catch (error) {
        this.logger.warn(`Failed to process ${basename}: ${error.message}`);
        failures.push(`${basename}: ${error.message}`);
      }
    }

    return { successes, failures };
  }

  /**
   * List articles with optional filters
   */
  async listArticles(query: ArticleListQueryDto): Promise<ArticleListItemDto[]> {
    const where: any = {};

    if (query.category) {
      where.category = query.category;
    }
    if (query.locale) {
      where.locale = query.locale;
    }
    if (query.status) {
      where.status = query.status;
    }

    return this.prisma.learnArticle.findMany({
      where,
      select: {
        id: true,
        category: true,
        locale: true,
        slug: true,
        title: true,
        status: true,
        updatedAt: true,
      },
      orderBy: [{ category: 'asc' }, { locale: 'asc' }, { title: 'asc' }],
    });
  }

  /**
   * Get a single article by ID (for editing)
   */
  async getArticleById(id: string) {
    const article = await this.prisma.learnArticle.findUnique({
      where: { id },
    });

    if (!article) {
      throw new BadRequestException('Article not found');
    }

    return article;
  }

  /**
   * Update an article
   */
  async updateArticle(id: string, data: UpdateArticleDto) {
    const article = await this.prisma.learnArticle.findUnique({
      where: { id },
    });

    if (!article) {
      throw new BadRequestException('Article not found');
    }

    return this.prisma.learnArticle.update({
      where: { id },
      data,
    });
  }
}

