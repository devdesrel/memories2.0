import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memories/screens/start.dart';


class MemoriesApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        title: 'Memories Brand',
        home: StartScreen()
    );
  }

}

void main() {
  runApp(
    MemoriesApp(),
  );
}

