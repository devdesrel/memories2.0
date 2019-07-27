import 'dart:ui';
import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memories/screens/start_page.dart';

import 'helpers/loader_animation.dart';

class MemoriesApp extends StatelessWidget {
  final Color primaryColor = const Color.fromRGBO(19, 141, 117, 1.0);
  final Color accentColor = const Color.fromRGBO(17, 122, 101, 1.0);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Memories Brand',
      home: TestAnimation(),
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        // primaryColor: primaryColor,
        // accentColor: accentColor,
        // iconTheme: IconThemeData(color: accentColor),
        buttonTheme: ButtonThemeData(
            // buttonColor: Color(0xFFCB2CE8), //for pink back
            buttonColor: Color(0xFF6236FF),
            textTheme: ButtonTextTheme.normal,
            colorScheme: ColorScheme.dark(primary: Colors.white),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0)),
        // scaffoldBackgroundColor: Color(0xFFFBDDFF), //for pink back
        scaffoldBackgroundColor: Colors.black,
        // textSelectionColor: Colors.black, //for pink back
        textSelectionColor: Colors.white,
        textTheme: TextTheme(
            title: TextStyle(color: Colors.white),
            headline: TextStyle(color: Colors.white54),
            display1: TextStyle(color: Colors.white)),
        brightness: Brightness.light,
        fontFamily: 'Quicksand',
        buttonColor: Color(0xFF6236FF),
      ),
    );
  }
}

void main() {
  runApp(
    MemoriesApp(),
  );
}

class TestAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StartPage(),
      ),
    );
  }
}
