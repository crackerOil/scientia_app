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
        iconTheme: IconThemeData(color: Colors.black),
      ),
      textTheme: TextTheme(
        subtitle1: TextStyle(
          color: Colors.black,
          fontFamily: 'Helvetica',
          fontSize: 20,
        ),
        subtitle2: TextStyle(
            color: Colors.black54
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

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      dividerColor: Colors.white70,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black26,
        titleSpacing: 5,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        subtitle1: TextStyle(
          color: Colors.white,
          fontFamily: 'Helvetica',
          fontSize: 20,
        ),
        headline5: TextStyle(
          color: Colors.white,
          fontFamily: 'Helvetica',
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
        headline6: TextStyle(
          color: Colors.white70,
          fontFamily: 'Helvetica',
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
