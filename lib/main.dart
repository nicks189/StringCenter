import 'package:flutter/material.dart';

import 'home.dart';
import 'create_measure.dart';
import 'log_in.dart';
import 'register.dart';
import 'tab_options.dart';
import 'profile.dart';
import 'tab.dart';
import 'viewtab.dart';
import 'viewtablist.dart';
import 'group_page.dart';
import 'followers.dart';
void main() {
  runApp(new StringCenter());
}
 ///StringCenter is a StatefulWidget which is the Widget ran by main in the app
///routes are declared here, as well as the the home Widget
class StringCenter extends StatefulWidget {
  _StringCenterState createState() => new _StringCenterState();
}

class _StringCenterState extends State<StringCenter> {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'StringCenter',
      routes: <String, WidgetBuilder> {
        'Home':(BuildContext context) => new Home(),
        'TabOptions':(BuildContext context) => new TabOptions(),
        'Login':(BuildContext context) => new Login(),
        'Register':(BuildContext context) => new Register(),
        'Profile':(BuildContext context) => new Profile(),
      },
      home: new Home(),
    );
  }
}