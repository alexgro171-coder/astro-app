import {
  Controller,
  Get,
  Put,
  Post,
  Delete,
  Body,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { BirthDataDto } from './dto/birth-data.dto';
import { RegisterDeviceDto } from './dto/register-device.dto';
import { User } from '@prisma/client';

@ApiTags('users')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('me')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  @ApiOperation({ summary: 'Get current user profile' })
  async getProfile(@CurrentUser() user: User) {
    return this.usersService.getProfile(user.id);
  }

  @Put()
  @ApiOperation({ summary: 'Update user profile' })
  async updateProfile(
    @CurrentUser() user: User,
    @Body() updateDto: UpdateProfileDto,
  ) {
    return this.usersService.updateProfile(user.id, updateDto);
  }

  @Post('birth-data')
  @ApiOperation({ summary: 'Set birth data and generate natal chart' })
  async setBirthData(
    @CurrentUser() user: User,
    @Body() birthDataDto: BirthDataDto,
  ) {
    return this.usersService.setBirthData(user.id, birthDataDto);
  }

  @Post('device')
  @ApiOperation({ summary: 'Register device with timezone and FCM token' })
  async registerDevice(
    @CurrentUser() user: User,
    @Body() registerDeviceDto: RegisterDeviceDto,
  ) {
    return this.usersService.registerDeviceV2(user.id, {
      deviceId: registerDeviceDto.deviceId,
      platform: registerDeviceDto.platform,
      timezoneIana: registerDeviceDto.timezoneIana,
      utcOffsetMinutes: registerDeviceDto.utcOffsetMinutes,
      fcmToken: registerDeviceDto.fcmToken,
      deviceToken: registerDeviceDto.deviceToken,
    });
  }

  @Delete()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Delete user account (GDPR)' })
  async deleteAccount(@CurrentUser() user: User) {
    return this.usersService.deleteAccount(user.id);
  }
}

