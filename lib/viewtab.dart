import 'package:flutter/material.dart';
import "dart:convert";
import "dart:io";
import 'tab.dart';

class ViewTab extends StatelessWidget {
  Tabb _t;

  ViewTab(Tabb t) {
    _t = t;
  }

  List<Tabb> tabs = new List<Tabb>();
  List<Widget> wl = new List<Widget>();

  /*class

  _viewTabState

  extends State<viewTab>*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('View Tab'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
          child: new Text(_t.tabToString()),
      ),
    );
  }
}