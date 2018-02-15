import 'package:flutter/material.dart';

import 'tab.dart';

class CreateMeasure extends StatefulWidget {
  String _title;
  String _info;
  String _tuning;

  int i = 3;

  CreateMeasure(String title, String info, String tuning) {
    _title = title;
    _info = info;
    _tuning = tuning;
  }

  _CreateMeasureState createState() => new _CreateMeasureState(_title, _info, _tuning);
}

class _CreateMeasureState extends State<CreateMeasure> {
  Tabb _t;
  Measure _m;
  
  _CreateMeasureState(String title, String info, String tuning) {
    Tabb t = new Tabb(title, info, tuning);
  }

  void _pressed() {
    setState((){

    });
  }

  List<Widget> generateNotes() {
    List<Widget> wlist = [];
    return wlist;
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Create Measure'),
      ),
      body: new Container(
        alignment: Alignment.center,
        child: new GridView.count(
          primary: false,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(20.0),
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 1.0,
          crossAxisCount: 6,

        )
      ),
    );
  }
}
