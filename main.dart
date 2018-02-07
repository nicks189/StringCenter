import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'tab.dart';

void main() {
  runApp(new StringCenter());
}

class StringCenter extends StatefulWidget {
  _StringCenterState createState() => new _StringCenterState();
}

class _StringCenterState extends State<StringCenter> {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'StringCenter',
      routes: <String, WidgetBuilder> {
        'home':(BuildContext context) => new HomeScreen(),
      },
      home: new HomeScreen(),
    );
  }
}