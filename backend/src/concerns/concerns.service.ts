import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AiService } from '../ai/ai.service';
import { CreateConcernDto } from './dto/create-concern.dto';
import { UpdateConcernDto } from './dto/update-concern.dto';
import { ConcernStatus, Language } from '@prisma/client';

@Injectable()
export class ConcernsService {
  constructor(
    private prisma: PrismaService,
    private aiService: AiService,
  ) {}

  async create(userId: string, createConcernDto: CreateConcernDto, language: Language) {
    const { text } = createConcernDto;

    // Classify the concern using AI
    const classification = await this.aiService.classifyConcern(text, language);

    // Create the concern
    const concern = await this.prisma.concern.create({
      data: {
        userId,
        textOriginal: text,
        category: classification.category,
        secondaryCategories: classification.secondaryCategories,
        modelConfidence: classification.confidence,
        status: 'ACTIVE',
      },
    });

    return {
      id: concern.id,
      category: concern.category,
      secondaryCategories: concern.secondaryCategories,
      confidence: concern.modelConfidence,
      startDate: concern.startDate,
      message: language === 'RO'
        ? 'Preocuparea ta a fost înregistrată. Începând de mâine, ghidarea ta zilnică va acorda mai multă atenție acestui subiect.'
        : 'Your concern has been recorded. Starting tomorrow, your daily guidance will pay more attention to this topic.',
    };
  }

  async findAll(userId: string) {
    const concerns = await this.prisma.concern.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });

    return {
      active: concerns.filter(c => c.status === 'ACTIVE'),
      resolved: concerns.filter(c => c.status === 'RESOLVED'),
      archived: concerns.filter(c => c.status === 'ARCHIVED'),
    };
  }

  async findActive(userId: string) {
    return this.prisma.concern.findFirst({
      where: {
        userId,
        status: 'ACTIVE',
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async findOne(userId: string, id: string) {
    const concern = await this.prisma.concern.findFirst({
      where: { id, userId },
    });

    if (!concern) {
      throw new NotFoundException('Concern not found');
    }

    return concern;
  }

  async update(userId: string, id: string, updateConcernDto: UpdateConcernDto) {
    const concern = await this.findOne(userId, id);

    const updateData: any = {};

    if (updateConcernDto.status) {
      updateData.status = updateConcernDto.status;
      
      if (updateConcernDto.status === 'RESOLVED') {
        updateData.endDate = new Date();
      }
    }

    if (updateConcernDto.text) {
      updateData.textOriginal = updateConcernDto.text;
    }

    return this.prisma.concern.update({
      where: { id },
      data: updateData,
    });
  }

  async resolve(userId: string, id: string) {
    await this.findOne(userId, id);

    return this.prisma.concern.update({
      where: { id },
      data: {
        status: 'RESOLVED',
        endDate: new Date(),
      },
    });
  }
}

