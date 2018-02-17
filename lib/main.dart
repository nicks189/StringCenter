import 'package:flutter/material.dart';

import 'package:ss_5/home.dart';
import 'package:ss_5/create_measure.dart';
import 'package:ss_5/log_in.dart';
import 'package:ss_5/register.dart';
import 'package:ss_5/tab_options.dart';
import 'package:ss_5/tab.dart';
import 'package:ss_5/viewtab.dart';
import 'package:ss_5/viewtablist.dart';

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
      },
      home: new Home(),
    );
  }
}