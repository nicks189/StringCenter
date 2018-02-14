import 'package:flutter/material.dart';

import 'home.dart';
import 'create_measure.dart';
import 'log_in.dart';
import 'register.dart';
import 'tab_options.dart';
import 'tab.dart';
import 'viewtab.dart';

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
        'home':(BuildContext context) => new Home(),
        'tabOptions':(BuildContext context) => new TabOptions(),
        'login':(BuildContext context) => new Login(),
        'register':(BuildContext context) => new Register(),
        'viewTab':(BuildContext context) => new viewTab(),
      },
      home: new Home(),
    );
  }
}