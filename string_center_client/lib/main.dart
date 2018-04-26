import 'package:flutter/material.dart';

import 'package:string_center_client/views/home.dart';
import 'package:string_center_client/views/create_measure.dart';
import 'package:string_center_client/views/log_in.dart';
import 'package:string_center_client/views/register.dart';
import 'package:string_center_client/views/tab_options.dart';
import 'package:string_center_client/views/profile.dart';
import 'package:string_center_client/data/tab.dart';
import 'package:string_center_client/views/viewtab.dart';
import 'package:string_center_client/views/viewtablist.dart';
import 'package:string_center_client/views/group_page.dart';
import 'package:string_center_client/views/followers.dart';

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
      routes: <String, WidgetBuilder>{
        'Home': (BuildContext context) => new Home(),
        'TabOptions': (BuildContext context) => new TabOptions(),
        'Login': (BuildContext context) => new Login(),
        'Register': (BuildContext context) => new Register(),
        'Profile': (BuildContext context) => new Profile(),
      },
      home: new Home(),
    );
  }
}
