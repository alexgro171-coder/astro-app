/// Models for natal chart placements and interpretations

class NatalPlacements {
  final List<PlanetPlacement> planets;
  final List<HouseCusp>? houses;
  final double? ascendantLongitude;
  final double? midheavenLongitude;

  NatalPlacements({
    required this.planets,
    this.houses,
    this.ascendantLongitude,
    this.midheavenLongitude,
  });

  factory NatalPlacements.fromJson(Map<String, dynamic> json) {
    return NatalPlacements(
      planets: (json['planets'] as List)
          .map((p) => PlanetPlacement.fromJson(p))
          .toList(),
      houses: json['houses'] != null
          ? (json['houses'] as List).map((h) => HouseCusp.fromJson(h)).toList()
          : null,
      ascendantLongitude: json['ascendantLongitude']?.toDouble(),
      midheavenLongitude: json['midheavenLongitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'planets': planets.map((p) => p.toJson()).toList(),
        if (houses != null) 'houses': houses!.map((h) => h.toJson()).toList(),
        if (ascendantLongitude != null)
          'ascendantLongitude': ascendantLongitude,
        if (midheavenLongitude != null) 'midheavenLongitude': midheavenLongitude,
      };

  /// Group planets by house for table view
  Map<int, List<PlanetPlacement>> get planetsByHouse {
    final grouped = <int, List<PlanetPlacement>>{};
    for (final planet in planets) {
      grouped.putIfAbsent(planet.house, () => []).add(planet);
    }
    // Sort by house number
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }
}

class PlanetPlacement {
  final String planet;
  final String sign;
  final int house;
  final double longitude;
  final bool? isRetrograde;

  PlanetPlacement({
    required this.planet,
    required this.sign,
    required this.house,
    required this.longitude,
    this.isRetrograde,
  });

  factory PlanetPlacement.fromJson(Map<String, dynamic> json) {
    return PlanetPlacement(
      planet: json['planet'] as String,
      sign: json['sign'] as String,
      house: json['house'] as int,
      longitude: (json['longitude'] as num).toDouble(),
      isRetrograde: json['isRetrograde'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'planet': planet,
        'sign': sign,
        'house': house,
        'longitude': longitude,
        if (isRetrograde != null) 'isRetrograde': isRetrograde,
      };

  String get displayTitle => '$planet in $sign';
  String get fullTitle => '$planet in $sign in ${_ordinal(house)} House';

  static String _ordinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }
}

class HouseCusp {
  final int house;
  final double cuspLongitude;
  final String sign;

  HouseCusp({
    required this.house,
    required this.cuspLongitude,
    required this.sign,
  });

  factory HouseCusp.fromJson(Map<String, dynamic> json) {
    return HouseCusp(
      house: json['house'] as int,
      cuspLongitude: (json['cuspLongitude'] as num).toDouble(),
      sign: json['sign'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'house': house,
        'cuspLongitude': cuspLongitude,
        'sign': sign,
      };
}

class NatalInterpretation {
  final String id;
  final String planetKey;
  final String sign;
  final int house;
  final String text;
  final bool isPro;
  final DateTime createdAt;

  NatalInterpretation({
    required this.id,
    required this.planetKey,
    required this.sign,
    required this.house,
    required this.text,
    required this.isPro,
    required this.createdAt,
  });

  factory NatalInterpretation.fromJson(Map<String, dynamic> json) {
    return NatalInterpretation(
      id: json['id'] as String,
      planetKey: json['planetKey'] as String,
      sign: json['sign'] as String,
      house: json['house'] as int,
      text: json['text'] as String,
      isPro: json['isPro'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'planetKey': planetKey,
        'sign': sign,
        'house': house,
        'text': text,
        'isPro': isPro,
        'createdAt': createdAt.toIso8601String(),
      };
}

class NatalChartData {
  final NatalPlacements placements;
  final List<NatalInterpretation> freeInterpretations;
  final List<NatalInterpretation>? proInterpretations;
  final bool hasProAccess;

  NatalChartData({
    required this.placements,
    required this.freeInterpretations,
    this.proInterpretations,
    this.hasProAccess = false,
  });

  factory NatalChartData.fromJson(Map<String, dynamic> json) {
    return NatalChartData(
      placements: NatalPlacements.fromJson(json['placements']),
      freeInterpretations: (json['freeInterpretations'] as List?)
              ?.map((i) => NatalInterpretation.fromJson(i))
              .toList() ??
          [],
      proInterpretations: json['proInterpretations'] != null
          ? (json['proInterpretations'] as List)
              .map((i) => NatalInterpretation.fromJson(i))
              .toList()
          : null,
      hasProAccess: json['hasProAccess'] as bool? ?? false,
    );
  }
}

/// Planet display info
class PlanetInfo {
  final String name;
  final String symbol;
  final String color;

  const PlanetInfo(this.name, this.symbol, this.color);

  static const Map<String, PlanetInfo> planets = {
    'Sun': PlanetInfo('Sun', '☉', '#FFD700'),
    'Moon': PlanetInfo('Moon', '☽', '#C0C0C0'),
    'Mercury': PlanetInfo('Mercury', '☿', '#87CEEB'),
    'Venus': PlanetInfo('Venus', '♀', '#FFC0CB'),
    'Mars': PlanetInfo('Mars', '♂', '#FF6347'),
    'Jupiter': PlanetInfo('Jupiter', '♃', '#9370DB'),
    'Saturn': PlanetInfo('Saturn', '♄', '#8B4513'),
    'Uranus': PlanetInfo('Uranus', '♅', '#00CED1'),
    'Neptune': PlanetInfo('Neptune', '♆', '#4169E1'),
    'Pluto': PlanetInfo('Pluto', '♇', '#800080'),
  };
}

/// Zodiac sign display info
class ZodiacInfo {
  final String name;
  final String symbol;
  final String element;
  final String color;

  const ZodiacInfo(this.name, this.symbol, this.element, this.color);

  static const Map<String, ZodiacInfo> signs = {
    'Aries': ZodiacInfo('Aries', '♈', 'Fire', '#FF0000'),
    'Taurus': ZodiacInfo('Taurus', '♉', 'Earth', '#228B22'),
    'Gemini': ZodiacInfo('Gemini', '♊', 'Air', '#FFD700'),
    'Cancer': ZodiacInfo('Cancer', '♋', 'Water', '#C0C0C0'),
    'Leo': ZodiacInfo('Leo', '♌', 'Fire', '#FFA500'),
    'Virgo': ZodiacInfo('Virgo', '♍', 'Earth', '#8B4513'),
    'Libra': ZodiacInfo('Libra', '♎', 'Air', '#FFC0CB'),
    'Scorpio': ZodiacInfo('Scorpio', '♏', 'Water', '#8B0000'),
    'Sagittarius': ZodiacInfo('Sagittarius', '♐', 'Fire', '#9400D3'),
    'Capricorn': ZodiacInfo('Capricorn', '♑', 'Earth', '#2F4F4F'),
    'Aquarius': ZodiacInfo('Aquarius', '♒', 'Air', '#00CED1'),
    'Pisces': ZodiacInfo('Pisces', '♓', 'Water', '#4169E1'),
  };
}

