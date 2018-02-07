import 'package:flutter/material.dart';

class TabOptions extends StatefulWidget {
  _TabOptionsState createState() => new _TabOptionsState();
}

class _TabOptionsState extends State<TabOptions> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('New Tab'),
      ),
    );
  }
}