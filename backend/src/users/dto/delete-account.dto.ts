import { ApiProperty } from '@nestjs/swagger';
import { IsString, Equals } from 'class-validator';

export class DeleteAccountDto {
  @ApiProperty({ 
    example: 'DELETE',
    description: 'Must be exactly "DELETE" to confirm account deletion'
  })
  @IsString()
  @Equals('DELETE', { message: 'Please type DELETE to confirm account deletion' })
  confirmation: string;
}

