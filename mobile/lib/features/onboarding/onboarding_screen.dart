import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

// Inner Wisdom Astro brand colors (from logo)
class OnboardingColors {
  static const Color purple = Color(0xFF6B4B8A);
  static const Color purpleDark = Color(0xFF5A3D7A);
  static const Color purpleLight = Color(0xFF7D5C9C);
  static const Color gold = Color(0xFFC9A86C);
  static const Color goldLight = Color(0xFFD4BC8A);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Inner Wisdom Astro',
      description:
          'Innerwisdom Astro brings together over 30 years of astrological expertise from Madi G. with the power of advanced AI, creating one of the most refined and high-performance astrology applications available today.\n\nBy blending deep human insight with intelligent technology, Innerwisdom Astro delivers interpretations that are precise, personalized, and meaningful, supporting users on their journey of self-discovery, clarity, and conscious growth.',
    ),
    OnboardingPage(
      title: 'Your Complete Astrological Journey',
      description:
          'From personalized daily guidance to your Natal Birth Chart, Karmic Astrology, in-depth personality reports, Love and Friendship Compatibility, Romantic Forecasts for Couples, and much more — all are now at your fingertips.\n\nDesigned to support clarity, connection, and self-understanding, Innerwisdom Astro offers a complete astrological experience, tailored to you.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              OnboardingColors.purpleLight,
              OnboardingColors.purple,
              OnboardingColors.purpleDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: OnboardingColors.goldLight.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index], index);
                  },
                ),
              ),

              // Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildIndicator(index),
                ),
              ).animate().fadeIn(delay: 800.ms, duration: 400.ms),

              const SizedBox(height: 32),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            context.go('/signup');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: OnboardingColors.gold,
                          foregroundColor: OnboardingColors.purpleDark,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentPage < _pages.length - 1
                              ? 'Next'
                              : 'Get Started',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          color: OnboardingColors.goldLight.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 1000.ms, duration: 400.ms).slideY(
                    begin: 0.2,
                    end: 0,
                    delay: 1000.ms,
                    duration: 400.ms,
                  ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, int index) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: OnboardingColors.gold.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to icon if image not found
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: OnboardingColors.purpleDark,
                        border: Border.all(
                          color: OnboardingColors.gold,
                          width: 3,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/InnerLogo_transp.png',
                        width: 80,
                        height: 80,
                      ),
                    );
                  },
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  curve: Curves.easeOutBack,
                )
                .then()
                .shimmer(
                  delay: 1500.ms,
                  duration: 1500.ms,
                  color: OnboardingColors.gold.withOpacity(0.3),
                ),

            const SizedBox(height: 40),

            // Title
            Text(
              page.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 500.ms)
                .slideY(begin: 0.3, end: 0, delay: 300.ms, duration: 500.ms),

            const SizedBox(height: 24),

            // Description
            Text(
              page.description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.9),
                height: 1.6,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 500.ms)
                .slideY(begin: 0.2, end: 0, delay: 500.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 28 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? OnboardingColors.gold
            : OnboardingColors.goldLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(5),
        boxShadow: _currentPage == index
            ? [
                BoxShadow(
                  color: OnboardingColors.gold.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;

  OnboardingPage({
    required this.title,
    required this.description,
  });
}
