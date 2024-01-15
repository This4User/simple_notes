import "package:flutter/material.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:simple_notes/domain/database/instance.dart";
import "package:simple_notes/domain/notifications/instance.dart";
import "package:simple_notes/ui/router/config.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarInstance.init();
  await NotificationsInstance.init();

  //TODO: remove this

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await NotificationsInstance.get.show(
      0, 'plain title', 'plain body', notificationDetails,
      payload: 'item x');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = AppRouter();

    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter.config(),
    );
  }
}
