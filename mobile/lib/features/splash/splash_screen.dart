import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/notification_service.dart';

// Inner Wisdom Astro brand colors (from logo)
class _SplashColors {
  static const Color purple = Color(0xFF6B4B8A);
  static const Color purpleDark = Color(0xFF5A3D7A);
  static const Color purpleLight = Color(0xFF7D5C9C);
  static const Color gold = Color(0xFFC9A86C);
  static const Color goldLight = Color(0xFFD4BC8A);
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Initialize notifications (request permissions if first time)
    unawaited(_initializeNotifications());

    await Future.delayed(AppConstants.splashDuration);

    if (!mounted) return;

    final apiClient = ref.read(apiClientProvider);
    final isLoggedIn = await apiClient
        .isLoggedIn()
        .timeout(const Duration(seconds: 8), onTimeout: () => false);

    if (!mounted) return;

    if (isLoggedIn) {
      // Check if user has completed onboarding
      try {
        final response = await apiClient
            .getProfile()
            .timeout(const Duration(seconds: 10));
        final user = response.data;
        
        // Schedule daily notification for logged-in users
        unawaited(_scheduleDailyNotification());
        
        if (user['onboardingComplete'] == true) {
          context.go('/home');
        } else {
          context.go('/birth-data');
        }
      } catch (e) {
        debugPrint('SplashScreen: Error getting profile: $e');
        context.go('/login');
      }
    } else {
      context.go('/onboarding');
    }
  }

  /// Initialize notifications and request permissions
  Future<void> _initializeNotifications() async {
    if (kIsWeb) return;
    
    try {
      final notificationService = NotificationService();
      
      // Check if already have permission
      final hasPermission = await notificationService.areNotificationsEnabled();
      
      if (!hasPermission) {
        // Request permission (will be shown to user)
        await notificationService.requestPermissions();
      }
    } catch (e) {
      print('SplashScreen: Error initializing notifications: $e');
    }
  }

  /// Schedule daily notification at 08:00
  Future<void> _scheduleDailyNotification() async {
    if (kIsWeb) return;
    
    try {
      final notificationService = NotificationService();
      await notificationService.scheduleDailyGuidanceNotification();
    } catch (e) {
      print('SplashScreen: Error scheduling notification: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _SplashColors.purpleLight,
              _SplashColors.purple,
              _SplashColors.purpleDark,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
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
                              color: _SplashColors.gold.withOpacity(0.4),
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
                                  color: _SplashColors.purpleDark,
                                  border: Border.all(
                                    color: _SplashColors.gold,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  size: 80,
                                  color: _SplashColors.gold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // App Name
                      const Text(
                        'Inner Wisdom Astro',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Tagline
                      Text(
                        'Your Personal Astrologer',
                        style: TextStyle(
                          fontSize: 16,
                          color: _SplashColors.goldLight.withOpacity(0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
