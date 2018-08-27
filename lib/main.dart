import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:memories/model.dart';
import 'package:memories/screens/start.dart';
import 'package:memories/screens/event.dart';


class MemoriesApp extends StatelessWidget {

  final MemoriesModel model;

  const MemoriesApp({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    model.refreshLocationAndEvents();
//    model.addListener(() ->)
    return ScopedModel<MemoriesModel>(
      model: model,
      child: MaterialApp(
        title: 'Memories Brand',
        initialRoute: '/',
        routes: {
          '/': (context) => StartScreen(),
          '/event': (context) => EventScreen(),
        },
      )
    );
  }

}

void main() {
  runApp(
    MemoriesApp(model: MemoriesModel(),),
  );
}
