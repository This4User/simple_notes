import "package:flutter_local_notifications/flutter_local_notifications.dart";

class NotificationsInstance {
  NotificationsInstance._();

  static late FlutterLocalNotificationsPlugin _instance;
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (!_isInitialized) {
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
      final initializationSettingsDarwin = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (int id, String? title, String? body,
                String? payload) =>
            print("Notification recieved: $id\n $title\n $body\n $payload\n"),
      );
      const initializationSettingsLinux =
          LinuxInitializationSettings(defaultActionName: "Open notification");
      final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux,
      );

      await notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) =>
            print("Notification recieved: $details"),
      );

      _isInitialized = true;
    } else {
      throw Exception("already initialized");
    }
  }

  static FlutterLocalNotificationsPlugin get get => _instance;
}
