import 'package:flutter/material.dart';
import "dart:convert";
import "dart:io";
import 'tab.dart';

class viewTab extends StatelessWidget {
  Tabb _t;
  viewTab(Tabb t){
    _t = t;
  }
  List<Tabb> tabs = new List<Tabb>();
  List<Widget> wl = new List<Widget>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('View Tab'),),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Text(_t.tabToString()),
        ),
      ),
    );
  }

}