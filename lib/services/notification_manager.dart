import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class NotificationManager {
  NotificationManager._();
  factory NotificationManager() => _manager;

  static final NotificationManager _manager = NotificationManager._();
  late final FirebaseMessaging _messaging;

  late final SharedPreferences _sharedPrefs;
  SharedPreferences get sharedPrefs => _sharedPrefs;

  bool _initialized = false;
  bool openedFromNotification = false;

  bool _enabled = false;
  bool get enabled => _enabled;

  Future<void> init() async {
    if (!_initialized) {
      await Firebase.initializeApp();

      _messaging = FirebaseMessaging.instance;
      _sharedPrefs = await SharedPreferences.getInstance()
          .then((prefs) async {
            if (prefs.getBool('notifications') == null || prefs.getBool('notifications')!) {
              NotificationSettings settings = await _messaging.requestPermission(
                alert: true,
                badge: true,
                provisional: false,
                sound: true,
              );

              if (settings.authorizationStatus == AuthorizationStatus.authorized) {
                print('User granted notification permissions');

                enableNotifications(prefs);

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

                FirebaseMessaging.onBackgroundMessage(
                    _firebaseMessagingBackgroundHandler);
              } else {
                print('User declined or has not accepted notification permissions');
              }
            }
            return prefs;
      });
      _initialized = true;
    }
  }

  void enableNotifications(SharedPreferences prefs) async {
    _enabled = true;

    _messaging.subscribeToTopic('Notifications');
    await prefs.setBool('notifications', true);

    print("Enabled notifications");
  }

  void disableNotifications(SharedPreferences prefs) async {
    _enabled = false;

    _messaging.unsubscribeFromTopic('Notifications');
    await prefs.setBool('notifications', false);

    print("Disabled notifications");
  }
}