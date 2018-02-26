import 'package:flutter/material.dart';

import 'globals.dart' as globals;

class Profile extends StatefulWidget {
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(globals.username),
      ),
    );
  }
}