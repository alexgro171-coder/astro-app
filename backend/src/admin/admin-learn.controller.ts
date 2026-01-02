import {
  Controller,
  Get,
  Post,
  Patch,
  Param,
  Query,
  Body,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiConsumes, ApiBody } from '@nestjs/swagger';
import { AdminGuard } from './guards/admin.guard';
import { AdminLearnService } from './admin-learn.service';
import { UpdateArticleDto, ArticleListQueryDto } from './dto/admin-learn.dto';

@ApiTags('Admin - Learn')
@ApiBearerAuth()
@Controller('admin/learn')
@UseGuards(AdminGuard)
export class AdminLearnController {
  constructor(private readonly adminLearnService: AdminLearnService) {}

  @Post('upload')
  @ApiOperation({ summary: 'Upload a single .md or .txt file' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
        },
      },
    },
  })
  @UseInterceptors(FileInterceptor('file'))
  async uploadFile(@UploadedFile() file: Express.Multer.File) {
    if (!file) {
      throw new BadRequestException('No file uploaded');
    }

    const filename = file.originalname;
    const content = file.buffer.toString('utf8');

    return this.adminLearnService.uploadFile(filename, content);
  }

  @Post('upload-zip')
  @ApiOperation({ summary: 'Upload a ZIP file with multiple articles' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
        },
      },
    },
  })
  @UseInterceptors(FileInterceptor('file'))
  async uploadZip(@UploadedFile() file: Express.Multer.File) {
    if (!file) {
      throw new BadRequestException('No file uploaded');
    }

    if (!file.originalname.endsWith('.zip')) {
      throw new BadRequestException('File must be a .zip archive');
    }

    return this.adminLearnService.uploadZip(file.buffer);
  }

  @Get('list')
  @ApiOperation({ summary: 'List all articles with optional filters' })
  async listArticles(@Query() query: ArticleListQueryDto) {
    return this.adminLearnService.listArticles(query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get article by ID for editing' })
  async getArticle(@Param('id') id: string) {
    return this.adminLearnService.getArticleById(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update article title, content, or status' })
  async updateArticle(@Param('id') id: string, @Body() body: UpdateArticleDto) {
    return this.adminLearnService.updateArticle(id, body);
  }
}

