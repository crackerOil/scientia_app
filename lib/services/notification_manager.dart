import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class NotificationManager {
  NotificationManager._();

  factory NotificationManager() => _manager;

  static final NotificationManager _manager = NotificationManager._();

  late final FirebaseMessaging _messaging;
  bool _initialized = false;
  bool openedFromNotification = false;

  Future<void> init() async {
    if (!_initialized) {
      await Firebase.initializeApp();

      _messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted notification permissions');

        _messaging.subscribeToTopic("Notifications");
        print("Subscribed user to 'Notifications' topic");

        // IOS heads up notification
        await _messaging.setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );

        // Android heads up notification
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          'This channel is used for important notifications.', // description
          importance: Importance.max,
        );
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      } else {
        print('User declined or has not accepted notification permissions');
      }
    }
  }
}