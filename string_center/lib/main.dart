import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import 'tab.dart';



void main() {
  runApp(new StringCenter());
}

class _StringCenterState extends State<StringCenter> {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: ,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Hello World"),
        ),
        body: new Container(
          alignment: Alignment.center,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class StringCenter extends StatefulWidget {
  _StringCenterState createState() => new _StringCenterState();
}