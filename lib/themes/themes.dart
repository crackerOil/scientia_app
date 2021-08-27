import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScientiaThemes {
  static ThemeData get light {
    return ThemeData(
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
        subtitle1: TextStyle(
          color: Colors.black,
          fontFamily: 'Helvetica',
          fontSize: 20,
        ),
        headline5: TextStyle(
          color: Colors.black,
          fontFamily: 'Helvetica',
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
        headline6: TextStyle(
          color: Color(0xff1f738b),
          fontFamily: 'Helvetica',
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // TODO: nice dark theme
  static ThemeData get dark {
    return ThemeData.dark();
  }
}
