import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memories/screens/start.dart';
import 'package:memories/screens/test.dart';

class MemoriesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(title: 'Memories Brand', home: TestPage());
  }
}

void main() {
  runApp(
    MemoriesApp(),
  );
}
