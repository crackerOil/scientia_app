import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scientia_app/screens/loading.dart';
import 'package:scientia_app/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Scientia App',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
      ),
      // initialRoute: '/home',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
      },
    );
  }
}
