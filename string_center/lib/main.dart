import 'package:flutter/material.dart';
import 'log_in.dart';
import 'home.dart';
import 'settings.dart';
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
      title: 'Navigation',
      routes: <String, WidgetBuilder> {
        '/home':(BuildContext context) => new Home(),
        '/settings':(BuildContext context) => new Settings(),
        '/login':(BuildContext context) => new Login(),
      },
      home: new Login(),
    );
  }
}