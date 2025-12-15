import 'dart:math';
import 'package:flutter/material.dart';

/// Animated starry background widget
/// Creates a cosmic atmosphere with twinkling stars
class StarryBackground extends StatefulWidget {
  final Widget child;
  final int starCount;
  final bool enableAnimation;

  const StarryBackground({
    super.key,
    required this.child,
    this.starCount = 100,
    this.enableAnimation = true,
  });

  @override
  State<StarryBackground> createState() => _StarryBackgroundState();
}

class _StarryBackgroundState extends State<StarryBackground>
    with TickerProviderStateMixin {
  late List<Star> _stars;
  late AnimationController _twinkleController;
  late AnimationController _shootingStarController;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeStars();
    _initializeAnimations();
  }

  void _initializeStars() {
    _stars = List.generate(widget.starCount, (index) {
      return Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 0.5,
        opacity: _random.nextDouble() * 0.5 + 0.3,
        twinkleSpeed: _random.nextDouble() * 2 + 1,
        twinkleOffset: _random.nextDouble() * 2 * pi,
      );
    });
  }

  void _initializeAnimations() {
    // Twinkle animation
    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    if (widget.enableAnimation) {
      _twinkleController.repeat();
    }

    // Shooting star animation
    _shootingStarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _twinkleController.dispose();
    _shootingStarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0a0a1a), // Deep space
                Color(0xFF1a1a3e), // Cosmic purple
                Color(0xFF0f1628), // Dark blue
                Color(0xFF0a0a14), // Near black
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        ),
        
        // Nebula effect (subtle colored areas)
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF6c5ce7).withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFd4af37).withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        
        // Stars
        AnimatedBuilder(
          animation: _twinkleController,
          builder: (context, child) {
            return CustomPaint(
              painter: StarPainter(
                stars: _stars,
                animationValue: _twinkleController.value,
                enableAnimation: widget.enableAnimation,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // Child content
        widget.child,
      ],
    );
  }
}

/// Represents a single star
class Star {
  final double x; // 0-1 relative position
  final double y;
  final double size;
  final double opacity;
  final double twinkleSpeed;
  final double twinkleOffset;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
    required this.twinkleOffset,
  });
}

/// Custom painter for stars
class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;
  final bool enableAnimation;

  StarPainter({
    required this.stars,
    required this.animationValue,
    required this.enableAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      // Calculate twinkle effect
      double currentOpacity = star.opacity;
      if (enableAnimation) {
        final twinkle = sin(animationValue * 2 * pi * star.twinkleSpeed + star.twinkleOffset);
        currentOpacity = star.opacity * (0.5 + 0.5 * twinkle);
      }

      final paint = Paint()
        ..color = Colors.white.withOpacity(currentOpacity.clamp(0.1, 1.0))
        ..style = PaintingStyle.fill;

      // Draw star with glow effect
      final x = star.x * size.width;
      final y = star.y * size.height;

      // Outer glow
      if (star.size > 1.5) {
        final glowPaint = Paint()
          ..color = const Color(0xFFd4af37).withOpacity(currentOpacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(Offset(x, y), star.size * 2, glowPaint);
      }

      // Star core
      canvas.drawCircle(Offset(x, y), star.size, paint);
    }
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) {
    return enableAnimation && oldDelegate.animationValue != animationValue;
  }
}

/// Shooting star widget (optional, can be added later)
class ShootingStar extends StatefulWidget {
  const ShootingStar({super.key});

  @override
  State<ShootingStar> createState() => _ShootingStarState();
}

class _ShootingStarState extends State<ShootingStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _startX = 0;
  double _startY = 0;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scheduleNextShootingStar();
  }

  void _scheduleNextShootingStar() {
    Future.delayed(Duration(seconds: _random.nextInt(10) + 5), () {
      if (mounted) {
        _startX = _random.nextDouble() * 0.5 + 0.3;
        _startY = _random.nextDouble() * 0.3;
        _controller.forward(from: 0).then((_) {
          _scheduleNextShootingStar();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (_animation.value == 0 || _animation.value == 1) {
          return const SizedBox.shrink();
        }
        
        return CustomPaint(
          painter: ShootingStarPainter(
            progress: _animation.value,
            startX: _startX,
            startY: _startY,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class ShootingStarPainter extends CustomPainter {
  final double progress;
  final double startX;
  final double startY;

  ShootingStarPainter({
    required this.progress,
    required this.startX,
    required this.startY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final startPoint = Offset(startX * size.width, startY * size.height);
    final endPoint = Offset(
      startPoint.dx + size.width * 0.3,
      startPoint.dy + size.height * 0.2,
    );

    final currentPoint = Offset.lerp(startPoint, endPoint, progress)!;
    final tailStart = Offset.lerp(startPoint, endPoint, (progress - 0.3).clamp(0, 1))!;

    // Draw tail
    final tailPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.5 * (1 - progress)),
          Colors.white.withOpacity(0.8 * (1 - progress)),
        ],
      ).createShader(Rect.fromPoints(tailStart, currentPoint));

    canvas.drawLine(tailStart, currentPoint, tailPaint..strokeWidth = 2);

    // Draw head
    final headPaint = Paint()
      ..color = Colors.white.withOpacity(1 - progress)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(currentPoint, 3, headPaint);
  }

  @override
  bool shouldRepaint(ShootingStarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

