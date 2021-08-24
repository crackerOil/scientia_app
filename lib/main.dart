import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:scientia_app/scientia_app.dart';
import 'package:scientia_app/services/notification_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    NotificationManager().init();

    // handle opening app (background) from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      setState(() {
        NotificationManager().openedFromNotification = true;
      });
    });

    // handle opening app (terminated) from notification
    () async {
      await Firebase.initializeApp();

      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        setState(() {
          NotificationManager().openedFromNotification = true;
        });
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return ScientiaApp();
  }
}
