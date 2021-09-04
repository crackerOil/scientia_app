import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scientia_app/screens/article.dart';
import 'package:scientia_app/screens/home.dart';
import 'package:scientia_app/screens/settings.dart';
import 'package:scientia_app/services/notification_manager.dart';
import 'package:scientia_app/themes/themes.dart';

class ScientiaApp extends StatefulWidget {
  ScientiaApp({Key? key}) : super(key: key);

  @override
  _ScientiaAppState createState() => _ScientiaAppState();

  static _ScientiaAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ScientiaAppState>();
}

class _ScientiaAppState extends State<ScientiaApp> {
  ThemeMode _themeMode = () {
    bool? darkTheme = NotificationManager().sharedPrefs.getBool('darkTheme');

    if (darkTheme == null || !darkTheme) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }();

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    () async {
      await NotificationManager()
          .sharedPrefs
          .setBool('darkTheme', themeMode == ThemeMode.dark);
    }();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Scientia App',
      theme: ScientiaThemes.light,
      darkTheme: ScientiaThemes.dark,
      themeMode: _themeMode,
      routes: {
        '/': (context) => AnimatedSplashScreen(
          duration: 2000,
          splash: Container(
            width: 300,
            child: Image(
              image: (_themeMode == ThemeMode.dark)
                  ? AssetImage('assets/logo-scientia-dark.png')
                  : AssetImage('assets/logo-scientia.png'),
              fit: BoxFit.fitWidth
            ),
          ),
          nextScreen: Home(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: (_themeMode == ThemeMode.dark) ? Colors.black54 : Colors.white,
        ),
      },
      // need to generate routes in order to bypass push animation
      onGenerateRoute: (settings) {
        if (settings.name == '/article') {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, __, ___) => Article(),
          );
        } else if (settings.name == '/settings') {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, __, ___) => Settings(),
          );
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
