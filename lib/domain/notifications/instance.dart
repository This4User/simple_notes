import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:flutter_timezone/flutter_timezone.dart";
import "package:timezone/data/latest_all.dart" as tz;
import "package:timezone/timezone.dart" as tz;

class NotificationsInstance {
  NotificationsInstance._();

  static late FlutterLocalNotificationsPlugin _instance;
  static bool _isInitialized = false;
  static String _localTimeZone = "";

  static Future<void> init() async {
    if (!_isInitialized) {
      _localTimeZone = await FlutterTimezone.getLocalTimezone();

      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation(_localTimeZone));

      final notificationsPlugin = _instance = FlutterLocalNotificationsPlugin();

      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      const initializationSettingsAndroid =
          AndroidInitializationSettings("app_icon");
      const initializationSettingsDarwin = DarwinInitializationSettings();
      const initializationSettingsLinux =
          LinuxInitializationSettings(defaultActionName: "Open notification");
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux,
      );

      await notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) =>
            print("Notification received: $details"),
      );

      await notificationsPlugin.cancelAll();
      _isInitialized = true;
    } else {
      throw Exception("already initialized");
    }
  }

  static Future<void> scheduleNotification({
    required String body,
    required String dateString,
    String title = "ColorNotes",
  }) async {
    if (!_isInitialized) return;

    await _instance.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.parse(tz.getLocation(_localTimeZone), dateString),
        const NotificationDetails(
          android: AndroidNotificationDetails("channel_id", "channel_name"),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static FlutterLocalNotificationsPlugin get get => _instance;
}
