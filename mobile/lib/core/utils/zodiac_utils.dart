import 'package:flutter/material.dart';

/// Zodiac sign data and utilities
class ZodiacUtils {
  /// Get zodiac data by sign name
  static ZodiacData? getZodiacData(String? signName) {
    if (signName == null) return null;
    return zodiacSigns[signName.toLowerCase()];
  }

  /// All zodiac signs with their data
  static final Map<String, ZodiacData> zodiacSigns = {
    'aries': ZodiacData(
      name: 'Aries',
      symbol: '♈',
      emoji: '🐏',
      element: 'Fire',
      color: const Color(0xFFE53935),
      gradient: const [Color(0xFFE53935), Color(0xFFFF7043)],
      dateRange: 'Mar 21 - Apr 19',
    ),
    'taurus': ZodiacData(
      name: 'Taurus',
      symbol: '♉',
      emoji: '🐂',
      element: 'Earth',
      color: const Color(0xFF43A047),
      gradient: const [Color(0xFF43A047), Color(0xFF66BB6A)],
      dateRange: 'Apr 20 - May 20',
    ),
    'gemini': ZodiacData(
      name: 'Gemini',
      symbol: '♊',
      emoji: '👯',
      element: 'Air',
      color: const Color(0xFFFFB300),
      gradient: const [Color(0xFFFFB300), Color(0xFFFFD54F)],
      dateRange: 'May 21 - Jun 20',
    ),
    'cancer': ZodiacData(
      name: 'Cancer',
      symbol: '♋',
      emoji: '🦀',
      element: 'Water',
      color: const Color(0xFF90A4AE),
      gradient: const [Color(0xFF78909C), Color(0xFFB0BEC5)],
      dateRange: 'Jun 21 - Jul 22',
    ),
    'leo': ZodiacData(
      name: 'Leo',
      symbol: '♌',
      emoji: '🦁',
      element: 'Fire',
      color: const Color(0xFFFF9800),
      gradient: const [Color(0xFFFF9800), Color(0xFFFFB74D)],
      dateRange: 'Jul 23 - Aug 22',
    ),
    'virgo': ZodiacData(
      name: 'Virgo',
      symbol: '♍',
      emoji: '👸',
      element: 'Earth',
      color: const Color(0xFF8D6E63),
      gradient: const [Color(0xFF6D4C41), Color(0xFFA1887F)],
      dateRange: 'Aug 23 - Sep 22',
    ),
    'libra': ZodiacData(
      name: 'Libra',
      symbol: '♎',
      emoji: '⚖️',
      element: 'Air',
      color: const Color(0xFFEC407A),
      gradient: const [Color(0xFFEC407A), Color(0xFFF48FB1)],
      dateRange: 'Sep 23 - Oct 22',
    ),
    'scorpio': ZodiacData(
      name: 'Scorpio',
      symbol: '♏',
      emoji: '🦂',
      element: 'Water',
      color: const Color(0xFF7B1FA2),
      gradient: const [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
      dateRange: 'Oct 23 - Nov 21',
    ),
    'sagittarius': ZodiacData(
      name: 'Sagittarius',
      symbol: '♐',
      emoji: '🏹',
      element: 'Fire',
      color: const Color(0xFF5C6BC0),
      gradient: const [Color(0xFF3F51B5), Color(0xFF7986CB)],
      dateRange: 'Nov 22 - Dec 21',
    ),
    'capricorn': ZodiacData(
      name: 'Capricorn',
      symbol: '♑',
      emoji: '🐐',
      element: 'Earth',
      color: const Color(0xFF455A64),
      gradient: const [Color(0xFF37474F), Color(0xFF607D8B)],
      dateRange: 'Dec 22 - Jan 19',
    ),
    'aquarius': ZodiacData(
      name: 'Aquarius',
      symbol: '♒',
      emoji: '🏺',
      element: 'Air',
      color: const Color(0xFF00ACC1),
      gradient: const [Color(0xFF0097A7), Color(0xFF26C6DA)],
      dateRange: 'Jan 20 - Feb 18',
    ),
    'pisces': ZodiacData(
      name: 'Pisces',
      symbol: '♓',
      emoji: '🐟',
      element: 'Water',
      color: const Color(0xFF7E57C2),
      gradient: const [Color(0xFF673AB7), Color(0xFF9575CD)],
      dateRange: 'Feb 19 - Mar 20',
    ),
  };

  /// Get element icon
  static IconData getElementIcon(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department;
      case 'earth':
        return Icons.landscape;
      case 'air':
        return Icons.air;
      case 'water':
        return Icons.water_drop;
      default:
        return Icons.star;
    }
  }

  /// Get element color
  static Color getElementColor(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return const Color(0xFFFF5722);
      case 'earth':
        return const Color(0xFF4CAF50);
      case 'air':
        return const Color(0xFF03A9F4);
      case 'water':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}

/// Data class for zodiac sign information
class ZodiacData {
  final String name;
  final String symbol;
  final String emoji;
  final String element;
  final Color color;
  final List<Color> gradient;
  final String dateRange;

  const ZodiacData({
    required this.name,
    required this.symbol,
    required this.emoji,
    required this.element,
    required this.color,
    required this.gradient,
    required this.dateRange,
  });
}

/// Widget to display zodiac sign with symbol
class ZodiacBadge extends StatelessWidget {
  final String? signName;
  final double size;
  final bool showName;

  const ZodiacBadge({
    super.key,
    this.signName,
    this.size = 40,
    this.showName = true,
  });

  @override
  Widget build(BuildContext context) {
    final zodiac = ZodiacUtils.getZodiacData(signName);
    
    if (zodiac == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            zodiac.gradient[0].withOpacity(0.3),
            zodiac.gradient[1].withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: zodiac.color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            zodiac.symbol,
            style: TextStyle(
              fontSize: size * 0.5,
              color: zodiac.color,
            ),
          ),
          if (showName) ...[
            const SizedBox(width: 6),
            Text(
              zodiac.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: zodiac.color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Animated zodiac symbol
class AnimatedZodiacSymbol extends StatefulWidget {
  final String? signName;
  final double size;

  const AnimatedZodiacSymbol({
    super.key,
    this.signName,
    this.size = 60,
  });

  @override
  State<AnimatedZodiacSymbol> createState() => _AnimatedZodiacSymbolState();
}

class _AnimatedZodiacSymbolState extends State<AnimatedZodiacSymbol>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zodiac = ZodiacUtils.getZodiacData(widget.signName);
    
    if (zodiac == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Icon(Icons.star, color: Colors.white54),
      );
    }

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                zodiac.color.withOpacity(_glowAnimation.value * 0.5),
                zodiac.color.withOpacity(_glowAnimation.value * 0.2),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: zodiac.color.withOpacity(_glowAnimation.value * 0.4),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              zodiac.symbol,
              style: TextStyle(
                fontSize: widget.size * 0.6,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: zodiac.color,
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

