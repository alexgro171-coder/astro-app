import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import 'fcm_service.dart';
import 'notification_service.dart';

/// Provider for DeviceService
final deviceServiceProvider = Provider<DeviceService>((ref) {
  return DeviceService(ref);
});

/// Service for device registration and management
/// 
/// Handles:
/// - Generating/storing stable device ID
/// - Getting device timezone
/// - Registering device with backend (timezone + FCM token)
/// - Scheduling local notifications
class DeviceService {
  final Ref _ref;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  static const String _deviceIdKey = 'stable_device_id';
  static const String _deviceRegisteredKey = 'device_registered_v2';
  
  DeviceService(this._ref);
  
  /// Get or generate a stable device identifier
  /// This ID persists across app reinstalls (stored in secure storage)
  Future<String> getOrCreateDeviceId() async {
    try {
      String? deviceId = await _storage.read(key: _deviceIdKey);
      
      if (deviceId == null) {
        // Generate a new UUID-like device ID
        deviceId = _generateUuid();
        await _storage.write(key: _deviceIdKey, value: deviceId);
        debugPrint('DeviceService: Generated new device ID: $deviceId');
      }
      
      return deviceId;
    } catch (e) {
      debugPrint('DeviceService: Error getting device ID: $e');
      // Fallback to a generated ID (won't persist on error)
      return _generateUuid();
    }
  }
  
  /// Generate a UUID v4-like string
  String _generateUuid() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return 'device-${random.toRadixString(16)}-${random ~/ 1000}';
  }
  
  /// Get device timezone (IANA format)
  Future<String> getTimezoneIana() async {
    try {
      return await FlutterTimezone.getLocalTimezone();
    } catch (e) {
      debugPrint('DeviceService: Error getting timezone: $e');
      return 'UTC';
    }
  }
  
  /// Get UTC offset in minutes
  int getUtcOffsetMinutes() {
    return DateTime.now().timeZoneOffset.inMinutes;
  }
  
  /// Get platform string
  String getPlatform() {
    if (kIsWeb) return 'WEB';
    if (Platform.isIOS) return 'IOS';
    if (Platform.isAndroid) return 'ANDROID';
    return 'UNKNOWN';
  }
  
  /// Full device registration flow:
  /// 1. Get/generate stable device ID
  /// 2. Get device timezone
  /// 3. Get FCM token (if available)
  /// 4. Register with backend
  /// 5. Schedule local notifications
  /// 
  /// Call this:
  /// - After successful login
  /// - On app start (if user is logged in)
  /// - When FCM token refreshes
  Future<bool> registerDeviceWithBackend({bool force = false}) async {
    if (kIsWeb) {
      debugPrint('DeviceService: Web platform - skipping device registration');
      return false;
    }
    
    try {
      // Check if already registered (unless forcing)
      if (!force) {
        final prefs = await SharedPreferences.getInstance();
        final registered = prefs.getBool(_deviceRegisteredKey) ?? false;
        if (registered) {
          debugPrint('DeviceService: Device already registered');
          return true;
        }
      }
      
      // Gather device info
      final deviceId = await getOrCreateDeviceId();
      final timezoneIana = await getTimezoneIana();
      final utcOffsetMinutes = getUtcOffsetMinutes();
      final platform = getPlatform();
      
      // Get FCM token (may be null if permissions not granted)
      final fcmService = _ref.read(fcmServiceProvider);
      String? fcmToken;
      try {
        fcmToken = await fcmService.getToken();
      } catch (e) {
        debugPrint('DeviceService: Could not get FCM token: $e');
      }
      
      debugPrint('DeviceService: Registering device...');
      debugPrint('  deviceId: $deviceId');
      debugPrint('  platform: $platform');
      debugPrint('  timezone: $timezoneIana');
      debugPrint('  utcOffset: $utcOffsetMinutes min');
      debugPrint('  fcmToken: ${fcmToken != null ? "present" : "null"}');
      
      // Register with backend
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.registerDevice(
        deviceId: deviceId,
        platform: platform,
        timezoneIana: timezoneIana,
        utcOffsetMinutes: utcOffsetMinutes,
        fcmToken: fcmToken,
      );
      
      // Mark as registered
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_deviceRegisteredKey, true);
      
      debugPrint('DeviceService: Device registered successfully');
      return true;
    } catch (e) {
      debugPrint('DeviceService: Failed to register device: $e');
      return false;
    }
  }
  
  /// Schedule local notifications (daily at 08:00)
  /// Call this after login and on app start
  Future<void> setupLocalNotifications() async {
    if (kIsWeb) return;
    
    try {
      final notificationService = _ref.read(notificationServiceProvider);
      
      // Request permission if not already granted
      final enabled = await notificationService.areNotificationsEnabled();
      if (!enabled) {
        final granted = await notificationService.requestPermissions();
        if (!granted) {
          debugPrint('DeviceService: Notification permission denied');
          return;
        }
      }
      
      // Schedule daily notification at 08:00
      await notificationService.scheduleDailyGuidanceNotification();
      debugPrint('DeviceService: Local notifications scheduled');
    } catch (e) {
      debugPrint('DeviceService: Error setting up notifications: $e');
    }
  }
  
  /// Full initialization: register device + setup notifications
  /// Call after successful login
  Future<void> initializeAfterLogin() async {
    debugPrint('DeviceService: Initializing after login...');
    
    // Register device with backend
    await registerDeviceWithBackend(force: true);
    
    // Setup local notifications
    await setupLocalNotifications();
    
    debugPrint('DeviceService: Initialization complete');
  }
  
  /// Re-register device (e.g., when FCM token changes)
  Future<void> onFcmTokenRefresh(String newToken) async {
    debugPrint('DeviceService: FCM token refreshed, re-registering...');
    await registerDeviceWithBackend(force: true);
  }
  
  /// Clear registration state (call on logout)
  Future<void> clearRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_deviceRegisteredKey, false);
    debugPrint('DeviceService: Registration cleared');
  }
  
  /// Check and reschedule notifications if timezone changed
  Future<void> checkTimezoneAndReschedule() async {
    if (kIsWeb) return;
    
    try {
      final notificationService = _ref.read(notificationServiceProvider);
      await notificationService.checkAndRescheduleIfTimezoneChanged();
    } catch (e) {
      debugPrint('DeviceService: Error checking timezone: $e');
    }
  }
}

