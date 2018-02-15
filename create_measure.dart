import 'package:flutter/material.dart';

import 'tab.dart';

class CreateMeasure extends StatefulWidget {
  String _title;
  String _info;
  String _tuning;

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
  int _noteCount;
  TextEditingController _noteController = new TextEditingController();

  _CreateMeasureState(String title, String info, String tuning) {
    _t = new Tabb(title, info, tuning);
    _m = new Measure('Null', _t.tuning.length, 0, _t.tuning);
    _noteCount = 0;
  }

  void _changed() {
    setState((){
      _noteCount = int.parse(_noteController.text);
      _m = new Measure("info", _t.tuning.length, _noteCount, _t.tuning);
    });
  }

  List<Widget> generateWidgets() {
    List<Widget> wlist = [];
    for(int i = 0; i < _t.tuning.length + 2; i++) {
      for (int j = 0; j < _noteCount; j++) {
        if (i == 0 && j == 0) {
          wlist.add(new TextField(
            controller: _noteController,
            maxLength: 1,
            maxLengthEnforced: true,
            onChanged: (_) {
              _changed();
            },
            decoration: new InputDecoration(
              hintText: 'Enter number of notes',
            ),
          ),);
        } else if (i == 0) {
          wlist.add(new Text(i.toString()));
        } else if (i == 1) {
          wlist.add(new Text(i.toString()));
        } else {
          wlist.add(new MaterialButton(
              child: new Text(_m.strings[i - 2].notes[j - 2]),
              onPressed: () {print('hello');}));
        }
      }
    }
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
              crossAxisCount: 2 + _m.stringCount,
              children: generateWidgets(),
            )
      ),
    );
  }
}