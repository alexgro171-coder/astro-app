import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Callback for handling notification taps (must be top-level function)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // This is handled in the foreground callback
  print('Notification tapped in background: ${notificationResponse.payload}');
}

/// Service for managing local notifications
/// Schedules daily guidance notification at 08:00 local time
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  // Notification IDs
  static const int dailyGuidanceNotificationId = 1;
  
  // Preferences keys
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _lastScheduledTimezoneKey = 'last_scheduled_timezone';
  
  // Callback for when notification is tapped
  Function(String? payload)? onNotificationTap;

  /// Initialize the notification service
  /// Call this in main() before runApp()
  Future<void> initialize() async {
    // Initialize timezone database
    tz_data.initializeTimeZones();
    
    // Get device timezone
    try {
      final String timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
      print('NotificationService: Timezone set to $timezoneName');
    } catch (e) {
      print('NotificationService: Error setting timezone: $e');
      // Fallback to UTC
      tz.setLocalLocation(tz.UTC);
    }

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    // Combined settings
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize plugin
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    print('NotificationService: Initialized successfully');
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    print('NotificationService: Notification tapped with payload: ${response.payload}');
    if (onNotificationTap != null) {
      onNotificationTap!(response.payload);
    }
  }

  /// Request notification permissions
  /// Returns true if permissions granted
  Future<bool> requestPermissions() async {
    if (kIsWeb) {
      print('NotificationService: Web platform - notifications not supported');
      return false;
    }

    bool granted = false;

    if (Platform.isAndroid) {
      // Android 13+ requires explicit permission
      final status = await Permission.notification.request();
      granted = status.isGranted;
      
      // Also request exact alarm permission for scheduling
      if (granted) {
        final exactAlarmStatus = await Permission.scheduleExactAlarm.request();
        print('NotificationService: Exact alarm permission: ${exactAlarmStatus.isGranted}');
      }
    } else if (Platform.isIOS) {
      // iOS permission request
      final result = await _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      granted = result ?? false;
    }

    print('NotificationService: Permission ${granted ? "granted" : "denied"}');
    
    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, granted);
    
    return granted;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) return false;
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? false;
  }

  /// Schedule daily guidance notification at 08:00 local time
  /// This notification will repeat every day
  Future<void> scheduleDailyGuidanceNotification() async {
    if (kIsWeb) {
      print('NotificationService: Skipping scheduling - Web platform');
      return;
    }

    final enabled = await areNotificationsEnabled();
    if (!enabled) {
      print('NotificationService: Notifications not enabled');
      return;
    }

    // Cancel existing notification first
    await cancelDailyGuidanceNotification();

    // Get current timezone
    final String currentTimezone = await FlutterTimezone.getLocalTimezone();
    final location = tz.getLocation(currentTimezone);
    
    // Calculate next 08:00 in local timezone
    final now = tz.TZDateTime.now(location);
    var scheduledDate = tz.TZDateTime(
      location,
      now.year,
      now.month,
      now.day,
      8, // 08:00
      0,
      0,
    );

    // If it's already past 08:00 today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    print('NotificationService: Scheduling notification for $scheduledDate (timezone: $currentTimezone)');

    // Notification details
    const androidDetails = AndroidNotificationDetails(
      'daily_guidance_channel',
      'Daily Guidance',
      channelDescription: 'Daily astrological guidance notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(
        'Ghidarea ta astrologică zilnică este pregătită. Descoperă ce îți rezervă astrele azi și cum să îți optimizezi ziua.',
        contentTitle: '✨ Ghidarea Zilnică Te Așteaptă',
        summaryText: 'Inner Wisdom',
      ),
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

    // Schedule repeating notification
    await _notifications.zonedSchedule(
      dailyGuidanceNotificationId,
      '✨ Ghidarea Zilnică Te Așteaptă',
      'Ghidarea ta astrologică zilnică este pregătită. Apasă pentru a o vedea.',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at same time
      payload: 'daily_guidance',
    );

    // Save timezone for later comparison
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastScheduledTimezoneKey, currentTimezone);

    print('NotificationService: Daily notification scheduled successfully');
  }

  /// Cancel the daily guidance notification
  Future<void> cancelDailyGuidanceNotification() async {
    await _notifications.cancel(dailyGuidanceNotificationId);
    print('NotificationService: Daily notification cancelled');
  }

  /// Check if timezone changed and reschedule if needed
  Future<void> checkAndRescheduleIfTimezoneChanged() async {
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();
    final lastTimezone = prefs.getString(_lastScheduledTimezoneKey);
    final currentTimezone = await FlutterTimezone.getLocalTimezone();

    if (lastTimezone != null && lastTimezone != currentTimezone) {
      print('NotificationService: Timezone changed from $lastTimezone to $currentTimezone');
      await scheduleDailyGuidanceNotification();
    }
  }

  /// Show an immediate test notification
  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Test notifications',
      importance: Importance.high,
      priority: Priority.high,
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

    await _notifications.show(
      999,
      '✨ Test Notification',
      'This is a test notification from Inner Wisdom',
      notificationDetails,
      payload: 'test',
    );
  }

  /// Get pending notifications (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}

