import 'package:flutter/material.dart';
import 'log_in.dart';
import 'home.dart';
import 'settings.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
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