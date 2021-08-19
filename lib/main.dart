import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        brightness: Brightness.light,
        dividerColor: Colors.black54,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleSpacing: 5,
          elevation: 0,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarBrightness: Brightness.light, // IOS
            statusBarIconBrightness: Brightness.dark, // Android
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            color: Color(0xff1f738b),
            fontFamily: 'Helvetica',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
