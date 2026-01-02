import {
  Controller,
  Get,
  Post,
  Param,
  BadRequestException,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiParam, ApiBearerAuth } from '@nestjs/swagger';
import { Request as ExpressRequest } from 'express';
import { LearnService } from './learn.service';
import { LearnCategory, Language } from '@prisma/client';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Public } from '../auth/decorators/public.decorator';

@ApiTags('Learn')
@Controller('learn')
@UseGuards(JwtAuthGuard)
export class LearnController {
  constructor(private readonly learnService: LearnService) {}

  @Get(':category/:locale/items')
  @Public()
  @ApiOperation({ summary: 'Get list of published articles for a category' })
  @ApiParam({ name: 'category', enum: LearnCategory })
  @ApiParam({ name: 'locale', enum: Language })
  async getItems(
    @Param('category') categoryStr: string,
    @Param('locale') localeStr: string,
  ) {
    const category = this.validateCategory(categoryStr);
    const locale = this.validateLocale(localeStr);
    return this.learnService.getItems(category, locale);
  }

  @Get(':category/:locale/:slug')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get a single article content' })
  @ApiParam({ name: 'category', enum: LearnCategory })
  @ApiParam({ name: 'locale', enum: Language })
  @ApiParam({ name: 'slug', type: String })
  async getArticle(
    @Param('category') categoryStr: string,
    @Param('locale') localeStr: string,
    @Param('slug') slug: string,
    @Request() req: ExpressRequest & { user?: { id: string } },
  ) {
    const category = this.validateCategory(categoryStr);
    const locale = this.validateLocale(localeStr);
    const userId = req.user?.id;
    return this.learnService.getArticle(category, locale, slug, userId);
  }

  @Post('opened')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Log that user opened Learn section' })
  async logOpened(@Request() req: ExpressRequest & { user?: { id: string } }) {
    const userId = req.user?.id;
    await this.learnService.logLearnOpened(userId);
    return { success: true };
  }

  private validateCategory(value: string): LearnCategory {
    const upper = value.toUpperCase();
    if (!Object.values(LearnCategory).includes(upper as LearnCategory)) {
      throw new BadRequestException(`Invalid category: ${value}`);
    }
    return upper as LearnCategory;
  }

  private validateLocale(value: string): Language {
    const upper = value.toUpperCase();
    if (!Object.values(Language).includes(upper as Language)) {
      throw new BadRequestException(`Invalid locale: ${value}`);
    }
    return upper as Language;
  }
}

