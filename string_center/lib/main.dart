import 'package:flutter/material.dart';

import 'dart:convert';

import 'tab.dart';


void main() {
  Tabb s = new Tabb("first tab");
  String encodedTab = JSON.encode(s);
  print(encodedTab);
  Tabb decodedTab = new Tabb.fromJson(encodedTab);
  print(decodedTab);


}

class _StringCenterState extends State<StringCenter> {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Hello World"),
        ),
        body: new Container(
          alignment: Alignment.bottomCenter,
          child: new RaisedButton(onPressed: null),
        ),
      ),
    );
  }

}

class StringCenter extends StatefulWidget {
  _StringCenterState createState() => new _StringCenterState();
}