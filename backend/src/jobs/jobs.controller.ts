import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  Headers,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiResponse,
  ApiParam,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { JobsService } from './jobs.service';
import { StartJobDto } from './dto/start-job.dto';
import { JobStartResponse, JobStatusResponse } from './dto/job-response.dto';

@ApiTags('Jobs')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('jobs')
export class JobsController {
  constructor(private readonly jobsService: JobsService) {}

  @Post('start')
  @ApiOperation({
    summary: 'Start a generation job (idempotent)',
    description:
      'Starts a compute-heavy generation job. Returns immediately with job ID for polling. Idempotent - calling multiple times for same input returns existing job.',
  })
  @ApiResponse({
    status: 200,
    description: 'Job started or existing job returned',
    type: JobStartResponse,
  })
  @ApiResponse({
    status: 404,
    description: 'User not found',
  })
  async startJob(
    @CurrentUser('id') userId: string,
    @Body() dto: StartJobDto,
    @Headers('accept-language') acceptLanguage?: string,
  ): Promise<JobStartResponse> {
    return this.jobsService.startJob(userId, dto, acceptLanguage);
  }

  @Get(':jobId')
  @ApiOperation({
    summary: 'Get job status',
    description:
      'Poll job status. Returns PENDING/RUNNING while processing, READY when complete with resultRef, or FAILED with errorMsg.',
  })
  @ApiParam({
    name: 'jobId',
    description: 'Job ID to check status',
  })
  @ApiResponse({
    status: 200,
    description: 'Job status returned',
    type: JobStatusResponse,
  })
  @ApiResponse({
    status: 404,
    description: 'Job not found',
  })
  @ApiResponse({
    status: 403,
    description: 'Access denied - job belongs to another user',
  })
  async getJobStatus(
    @CurrentUser('id') userId: string,
    @Param('jobId') jobId: string,
  ): Promise<JobStatusResponse> {
    return this.jobsService.getJobStatus(userId, jobId);
  }

  @Post(':jobId/retry')
  @ApiOperation({
    summary: 'Retry a failed job',
    description: 'Re-queues a failed job for processing. Only works on FAILED jobs.',
  })
  @ApiParam({
    name: 'jobId',
    description: 'Job ID to retry',
  })
  @ApiResponse({
    status: 200,
    description: 'Job retry initiated',
    type: JobStartResponse,
  })
  @ApiResponse({
    status: 404,
    description: 'Job not found',
  })
  @ApiResponse({
    status: 403,
    description: 'Access denied',
  })
  async retryJob(
    @CurrentUser('id') userId: string,
    @Param('jobId') jobId: string,
  ): Promise<JobStartResponse> {
    return this.jobsService.retryJob(userId, jobId);
  }

  @Get('admin/stats')
  @ApiOperation({
    summary: 'Get queue statistics (admin)',
    description: 'Returns current queue and running job counts.',
  })
  getQueueStats() {
    return this.jobsService.getQueueStats();
  }
}

