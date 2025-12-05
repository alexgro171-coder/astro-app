import {
  Controller,
  Get,
  Post,
  Patch,
  Param,
  Body,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { ConcernsService } from './concerns.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { CreateConcernDto } from './dto/create-concern.dto';
import { UpdateConcernDto } from './dto/update-concern.dto';
import { User } from '@prisma/client';

@ApiTags('concerns')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('concerns')
export class ConcernsController {
  constructor(private readonly concernsService: ConcernsService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new concern' })
  async create(
    @CurrentUser() user: User,
    @Body() createConcernDto: CreateConcernDto,
  ) {
    return this.concernsService.create(user.id, createConcernDto, user.language);
  }

  @Get()
  @ApiOperation({ summary: 'Get all user concerns' })
  async findAll(@CurrentUser() user: User) {
    return this.concernsService.findAll(user.id);
  }

  @Get('active')
  @ApiOperation({ summary: 'Get active concern' })
  async findActive(@CurrentUser() user: User) {
    const concern = await this.concernsService.findActive(user.id);
    return {
      hasConcern: !!concern,
      concern,
    };
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a specific concern' })
  async findOne(@CurrentUser() user: User, @Param('id') id: string) {
    return this.concernsService.findOne(user.id, id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update a concern' })
  async update(
    @CurrentUser() user: User,
    @Param('id') id: string,
    @Body() updateConcernDto: UpdateConcernDto,
  ) {
    return this.concernsService.update(user.id, id, updateConcernDto);
  }

  @Post(':id/resolve')
  @ApiOperation({ summary: 'Mark a concern as resolved' })
  async resolve(@CurrentUser() user: User, @Param('id') id: string) {
    return this.concernsService.resolve(user.id, id);
  }
}

