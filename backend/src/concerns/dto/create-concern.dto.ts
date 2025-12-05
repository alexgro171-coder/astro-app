import { ApiProperty } from '@nestjs/swagger';
import { IsString, MinLength, MaxLength } from 'class-validator';

export class CreateConcernDto {
  @ApiProperty({
    example: 'Am o ofertă de job în alt oraș și nu știu dacă să o accept.',
    description: 'The concern or problem in natural language',
  })
  @IsString()
  @MinLength(10)
  @MaxLength(2000)
  text: string;
}

