import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';


import 'globals.dart' as globals;

class Profile extends StatefulWidget {
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {

  AssetImage i = new AssetImage('images/einstein.jpg');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: i
          ),
        ),
      ),
    );
  }
}