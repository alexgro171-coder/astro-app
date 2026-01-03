import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/reset_password_screen.dart';
import '../../features/auth/birth_data_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/guidance/guidance_detail_screen.dart';
import '../../features/concerns/add_concern_screen.dart';
import '../../features/concerns/concerns_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/delete_account_screen.dart';
import '../../features/profile/notifications_settings_screen.dart';
import '../../features/profile/appearance_screen.dart';
import '../../features/profile/help_support_screen.dart';
import '../../features/profile/terms_screen.dart';
import '../../features/profile/privacy_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/context/screens/context_wizard_screen.dart';
import '../../features/context/models/context_answers.dart';
import '../../features/for_you/for_you_screen.dart';
import '../../features/for_you/free_learn_screen.dart';
import '../../features/natal_chart/natal_chart_screen.dart';
import '../../features/natal_chart/pro_natal_offer_screen.dart';
import '../../features/natal_chart/pro_natal_checkout_screen.dart';
import '../../features/karmic/karmic_offer_screen.dart';
import '../../features/karmic/karmic_result_screen.dart';
import '../../features/learn/services/learn_service.dart';
import '../../features/learn/screens/category_items_screen.dart';
import '../../features/learn/screens/article_screen.dart';
import '../widgets/placeholder_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // Auth & Onboarding routes (no shell)
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final email = state.extra as String?;
          return ResetPasswordScreen(email: email);
        },
      ),
      GoRoute(
        path: '/birth-data',
        builder: (context, state) => const BirthDataScreen(),
      ),
      
      // Context Wizard (onboarding step after birth data)
      GoRoute(
        path: '/context-wizard',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ContextWizardScreen(
            isOnboarding: extra?['isOnboarding'] as bool? ?? false,
            existingAnswers: extra?['existingAnswers'] as ContextAnswers?,
          );
        },
      ),
      
      // Main app routes with shell (bottom navigation)
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HistoryScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/concerns',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ConcernsScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/delete-account',
            builder: (context, state) => const DeleteAccountScreen(),
          ),
          GoRoute(
            path: '/notifications-settings',
            builder: (context, state) => const NotificationsSettingsScreen(),
          ),
          GoRoute(
            path: '/appearance',
            builder: (context, state) => const AppearanceScreen(),
          ),
          GoRoute(
            path: '/help-support',
            builder: (context, state) => const HelpSupportScreen(),
          ),
          GoRoute(
            path: '/terms-of-service',
            builder: (context, state) => const TermsScreen(),
          ),
          GoRoute(
            path: '/privacy-policy',
            builder: (context, state) => const PrivacyScreen(),
          ),
          GoRoute(
            path: '/for-you',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ForYouScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
        ],
      ),
      
      // Detail routes (no shell - full screen)
      GoRoute(
        path: '/guidance/:id',
        builder: (context, state) => GuidanceDetailScreen(
          guidanceId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/add-concern',
        builder: (context, state) => const AddConcernScreen(),
      ),
      
      // Natal Chart routes
      GoRoute(
        path: '/natal-chart',
        builder: (context, state) => const NatalChartScreen(),
      ),
      GoRoute(
        path: '/pro-natal-offer',
        builder: (context, state) => const ProNatalOfferScreen(),
      ),
      GoRoute(
        path: '/pro-natal-checkout',
        builder: (context, state) => const ProNatalCheckoutScreen(),
      ),
      
      // Free Learn Screen
      GoRoute(
        path: '/free-learn',
        builder: (context, state) => const FreeLearnScreen(),
      ),
      
      // Learn category items
      GoRoute(
        path: '/learn/:category/:locale',
        builder: (context, state) {
          final categoryStr = state.pathParameters['category']!;
          final locale = state.pathParameters['locale']!;
          final category = LearnCategory.values.firstWhere(
            (c) => c.name == categoryStr,
            orElse: () => LearnCategory.signs,
          );
          return CategoryItemsScreen(
            category: category,
            locale: locale,
          );
        },
      ),
      
      // Learn article detail
      GoRoute(
        path: '/learn/:category/:locale/:slug',
        builder: (context, state) {
          final categoryStr = state.pathParameters['category']!;
          final locale = state.pathParameters['locale']!;
          final slug = state.pathParameters['slug']!;
          final category = LearnCategory.values.firstWhere(
            (c) => c.name == categoryStr,
            orElse: () => LearnCategory.signs,
          );
          return ArticleScreen(
            category: category,
            locale: locale,
            slug: slug,
          );
        },
      ),
      
      // Karmic Astrology
      GoRoute(
        path: '/karmic-astrology',
        builder: (context, state) => const KarmicOfferScreen(),
      ),
      GoRoute(
        path: '/karmic-result',
        builder: (context, state) => const KarmicResultScreen(),
      ),
      
      // Generic placeholder for coming soon features
      GoRoute(
        path: '/placeholder',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PlaceholderScreen(
            title: extra?['title'] as String? ?? 'Coming Soon',
            subtitle: extra?['subtitle'] as String? ?? 'This feature is coming soon',
            icon: extra?['icon'] as IconData?,
          );
        },
      ),
    ],
  );
});
