import 'dart:ui';

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
              buttonColor: Color(0xFFCB2CE8),
              textTheme: ButtonTextTheme.normal,
              colorScheme: ColorScheme.dark(primary: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0)),
          scaffoldBackgroundColor: Color(0xFFFBDDFF),
          textSelectionColor: Colors.black,
          brightness: Brightness.light,
          fontFamily: 'Quicksand'),
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
