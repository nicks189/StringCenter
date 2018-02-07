import 'package:flutter/material.dart';

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
      title: 'StringCenter Home',
      routes: <String, WidgetBuilder> {
        //'home':(BuildContext context) => new Home(),

      },
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('StringCenter Home'),
        ),
      ),
    );
  }
}