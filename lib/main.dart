import 'package:flutter/material.dart';
import 'package:scientia_app/scientia_app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // if (snapshot.hasError) {
        //   return SomethingWentWrong();
        // }

        // Once complete, show the application
        if (snapshot.connectionState == ConnectionState.done) {
          return ScientiaApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator()
            )
          ),
          debugShowCheckedModeBanner: false,
        );
      }
    );
  }
}
