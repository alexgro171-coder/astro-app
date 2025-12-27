import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';

/// Global navigator key for navigation from notification tap
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Provider for pending navigation (set when notification is tapped)
final pendingNavigationProvider = StateProvider<String?>((ref) => null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Lock orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize notification service (skip on web)
  if (!kIsWeb) {
    await NotificationService().initialize();
  }

  runApp(const ProviderScope(child: AstroApp()));
}

class AstroApp extends ConsumerStatefulWidget {
  const AstroApp({super.key});

  @override
  ConsumerState<AstroApp> createState() => _AstroAppState();
}

class _AstroAppState extends ConsumerState<AstroApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Setup notification tap handler
    _setupNotificationHandler();
    
    // Check timezone changes on startup
    _checkTimezoneAndReschedule();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Called when app lifecycle state changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed) {
      // App came to foreground - check timezone
      _checkTimezoneAndReschedule();
      
      // Check for pending navigation
      _handlePendingNavigation();
    }
  }

  /// Setup notification tap handler
  void _setupNotificationHandler() {
    if (kIsWeb) return;
    
    NotificationService().onNotificationTap = (String? payload) {
      print('main.dart: Notification tapped with payload: $payload');
      
      if (payload == 'daily_guidance') {
        // Set pending navigation - will be handled when router is ready
        ref.read(pendingNavigationProvider.notifier).state = '/home';
        _handlePendingNavigation();
      }
    };
  }

  /// Handle pending navigation from notification
  void _handlePendingNavigation() {
    final pendingRoute = ref.read(pendingNavigationProvider);
    if (pendingRoute != null) {
      print('main.dart: Handling pending navigation to $pendingRoute');
      
      // Use router to navigate
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final router = ref.read(routerProvider);
        router.go(pendingRoute);
        
        // Clear pending navigation
        ref.read(pendingNavigationProvider.notifier).state = null;
      });
    }
  }

  /// Check if timezone changed and reschedule notifications
  Future<void> _checkTimezoneAndReschedule() async {
    if (kIsWeb) return;
    
    try {
      await NotificationService().checkAndRescheduleIfTimezoneChanged();
    } catch (e) {
      print('main.dart: Error checking timezone: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Inner Wisdom',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
