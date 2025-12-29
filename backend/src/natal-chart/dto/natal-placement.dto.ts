import { IsString, IsNumber, IsBoolean, IsOptional, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class PlanetPlacementDto {
  @IsString()
  planet: string;

  @IsString()
  sign: string;

  @IsNumber()
  house: number;

  @IsNumber()
  longitude: number;

  @IsOptional()
  @IsBoolean()
  isRetrograde?: boolean;
}

export class HouseCuspDto {
  @IsNumber()
  house: number;

  @IsNumber()
  cuspLongitude: number;

  @IsString()
  sign: string;
}

export class NatalPlacementsDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PlanetPlacementDto)
  planets: PlanetPlacementDto[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => HouseCuspDto)
  houses?: HouseCuspDto[];

  @IsOptional()
  @IsNumber()
  ascendantLongitude?: number;

  @IsOptional()
  @IsNumber()
  midheavenLongitude?: number;
}

export class NatalInterpretationDto {
  @IsString()
  id: string;

  @IsString()
  planetKey: string;

  @IsString()
  sign: string;

  @IsNumber()
  house: number;

  @IsString()
  text: string;

  @IsBoolean()
  isPro: boolean;

  @IsString()
  createdAt: string;
}

export class NatalChartDataDto {
  placements: NatalPlacementsDto;
  freeInterpretations: NatalInterpretationDto[];
  proInterpretations?: NatalInterpretationDto[];
  hasProAccess: boolean;
}

