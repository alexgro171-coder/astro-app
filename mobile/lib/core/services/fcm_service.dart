import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import 'device_service.dart';

/// Provider for FCMService
final fcmServiceProvider = Provider<FCMService>((ref) {
  final service = FCMService(ref);
  // Check for pending token registration when provider is accessed
  service._checkPendingTokenRegistration();
  return service;
});

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCMService: Background message received: ${message.messageId}');
  debugPrint('FCMService: Data: ${message.data}');
  // Note: Firebase automatically shows the notification for data+notification messages
  // We only need to handle data-only messages here if needed
}

/// Service for handling Firebase Cloud Messaging (Push Notifications)
class FCMService {
  static final FCMService _instance = FCMService._internal(null);
  
  factory FCMService([Ref? ref]) {
    if (ref != null) {
      _instance._ref = ref;
    }
    return _instance;
  }
  
  FCMService._internal(this._ref);
  
  Ref? _ref;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  // Preferences keys
  static const String _fcmTokenKey = 'fcm_token';
  static const String _tokenRegisteredKey = 'fcm_token_registered';
  
  // Callback for handling notification taps
  Function(Map<String, dynamic> data)? onNotificationTap;
  
  /// Initialize FCM service
  /// Call this after Firebase.initializeApp() in main.dart
  Future<void> initialize() async {
    if (kIsWeb) {
      debugPrint('FCMService: Web platform - FCM not fully supported');
      return;
    }

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Initialize local notifications for foreground handling
    await _initializeLocalNotifications();

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Listen for notification taps when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from a terminated state notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('FCMService: App opened from terminated state notification');
      _handleNotificationTap(initialMessage);
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen(_onTokenRefresh);

    debugPrint('FCMService: Initialized successfully');
  }

  /// Initialize local notifications for showing foreground notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('FCMService: Local notification tapped: ${response.payload}');
        // Parse payload and call tap handler
        if (response.payload != null && onNotificationTap != null) {
          try {
            // Simple payload parsing - extend as needed
            onNotificationTap!({'screen': response.payload});
          } catch (e) {
            debugPrint('FCMService: Error parsing notification payload: $e');
          }
        }
      },
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'daily_guidance',
        'Daily Guidance',
        description: 'Notifications for daily astrological guidance',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Request notification permissions and get FCM token
  /// Returns the FCM token if successful, null otherwise
  Future<String?> requestPermissionsAndGetToken() async {
    if (kIsWeb) return null;

    try {
      // Request permission
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );

      debugPrint('FCMService: Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Get FCM token
        final token = await _messaging.getToken();
        debugPrint('FCMService: FCM Token: $token');
        
        if (token != null) {
          // Save token locally
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_fcmTokenKey, token);
        }
        
        return token;
      } else {
        debugPrint('FCMService: Notification permission denied');
        return null;
      }
    } catch (e) {
      debugPrint('FCMService: Error requesting permissions: $e');
      return null;
    }
  }

  /// Register FCM token with backend
  /// Call this after successful login
  Future<bool> registerTokenWithBackend() async {
    if (kIsWeb || _ref == null) return false;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_fcmTokenKey);
      
      if (token == null) {
        // Try to get token first
        final newToken = await _messaging.getToken();
        if (newToken == null) {
          debugPrint('FCMService: No FCM token available');
          return false;
        }
        await prefs.setString(_fcmTokenKey, newToken);
        return await _registerToken(newToken);
      }
      
      // Check if already registered
      final isRegistered = prefs.getBool(_tokenRegisteredKey) ?? false;
      if (isRegistered) {
        debugPrint('FCMService: Token already registered');
        return true;
      }
      
      return await _registerToken(token);
    } catch (e) {
      debugPrint('FCMService: Error registering token: $e');
      return false;
    }
  }

  /// Check for pending token registration (called when _ref becomes available)
  Future<void> _checkPendingTokenRegistration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_fcmTokenKey);
      final isRegistered = prefs.getBool(_tokenRegisteredKey) ?? false;
      
      if (token != null && !isRegistered && _ref != null) {
        debugPrint('FCMService: Found pending token registration, registering now...');
        await _registerToken(token);
      }
    } catch (e) {
      debugPrint('FCMService: Error checking pending token registration: $e');
    }
  }

  /// Internal method to register token with backend
  Future<bool> _registerToken(String token) async {
    if (_ref == null) {
      debugPrint('FCMService: Cannot register token - _ref is null (provider not yet accessed)');
      return false;
    }
    
    try {
      final platform = Platform.isIOS ? 'IOS' : 'ANDROID';
      final apiClient = _ref!.read(apiClientProvider);
      final deviceService = _ref!.read(deviceServiceProvider);
      final deviceId = await deviceService.getOrCreateDeviceId();
      
      await apiClient.registerDevice(
        deviceId: deviceId,
        deviceToken: token,
        platform: platform,
      );
      
      // Mark as registered
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_tokenRegisteredKey, true);
      
      debugPrint('FCMService: Token registered with backend successfully');
      return true;
    } catch (e) {
      debugPrint('FCMService: Failed to register token with backend: $e');
      return false;
    }
  }

  /// Handle token refresh
  Future<void> _onTokenRefresh(String token) async {
    try {
      debugPrint('FCMService: Token refreshed: $token');
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_fcmTokenKey, token);
      // Reset registration flag to force re-registration
      await prefs.setBool(_tokenRegisteredKey, false);
      
      // Register new token with backend
      await registerTokenWithBackend();
    } catch (e) {
      debugPrint('FCMService: Error handling token refresh: $e');
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('FCMService: Foreground message received: ${message.messageId}');
    debugPrint('FCMService: Title: ${message.notification?.title}');
    debugPrint('FCMService: Body: ${message.notification?.body}');
    debugPrint('FCMService: Data: ${message.data}');

    // Show local notification
    _showLocalNotification(message);
  }

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'daily_guidance',
      'Daily Guidance',
      channelDescription: 'Notifications for daily astrological guidance',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
      payload: message.data['screen'] ?? 'guidance',
    );
  }

  /// Handle notification tap (from background/terminated state)
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('FCMService: Notification tapped: ${message.messageId}');
    debugPrint('FCMService: Data: ${message.data}');

    if (onNotificationTap != null) {
      onNotificationTap!(message.data);
    }
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('FCMService: Error getting token: $e');
      return null;
    }
  }

  /// Clear registration state (call on logout)
  Future<void> clearRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tokenRegisteredKey, false);
    debugPrint('FCMService: Registration cleared');
  }

  /// Delete FCM token (call on logout if needed)
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_fcmTokenKey);
      await prefs.setBool(_tokenRegisteredKey, false);
      debugPrint('FCMService: Token deleted');
    } catch (e) {
      debugPrint('FCMService: Error deleting token: $e');
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('FCMService: Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('FCMService: Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('FCMService: Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('FCMService: Error unsubscribing from topic: $e');
    }
  }
}

