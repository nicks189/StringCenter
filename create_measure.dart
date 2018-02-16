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

  _CreateMeasureState createState() =>
      new _CreateMeasureState(_title, _info, _tuning);
}

class _CreateMeasureState extends State<CreateMeasure> {
  Tabb _t;
  Measure _m;
  int _noteCount;
  TextEditingController _noteController = new TextEditingController();
  TextEditingController _symbolController = new TextEditingController();

  _CreateMeasureState(String title, String info, String tuning) {
    _t = new Tabb(title, info, tuning);
    _m = new Measure('Null', _t.tuning.length, 0, _t.tuning);
    _noteCount = 0;
  }

  void _newMeasure() {
    setState(() {
      _noteCount = int.parse(_noteController.text);
      _m = new Measure("info", _t.tuning.length, _noteCount, _t.tuning);
    });
  }

  void _changeNote(int i, int j) {
    setState(() {
      if (j != null && i != null) {
        _m.strings[j - 2].notes[i] = _symbolController.text;
      }
    });
  }

  List<Widget> generateWidgets() {
    List<Widget> wlist = [];
    wlist.add(
      new TextField(
        controller: _noteController,
        maxLength: 2,
        maxLengthEnforced: true,
        onChanged: (_) {
          _newMeasure();
        },
        decoration: new InputDecoration(
          hintText: '# of notes',
        ),
      ),
    );
    wlist.add(new Text(''));
    for (int i = _t.tuning.length - 1; i >= 0; i--) {
      wlist.add(
        new Text(
          _t.tuning[i],
          textAlign: TextAlign.center,
        ),
      );
    }
    wlist.add(new Text(''));
    for (int i = 0; i < _noteCount; i++) {
      for (int j = 0; j < _t.tuning.length + 2; j++) {
        if (i == 0 && j == 0) {} else if (i == 1 && j == 0) {
          wlist.add(
            new TextField(
              controller: _symbolController,
              maxLength: 2,
              maxLengthEnforced: true,
              onChanged: (_) {},
              decoration: new InputDecoration(
                hintText: 'symbol',
              ),
            ),
          );
        } else if (j == 0) {
          wlist.add(new Text(''));
        } else if (j == 1) {
          wlist.add(new Text(
            i.toString(),
            textAlign: TextAlign.center,
          ));
        } else {
          wlist.add(new MaterialButton(
              child: new Text(
                _m.strings[j - 2].notes[i],
              ),
              onPressed: () {
                _changeNote(i, j);
              }));
        }
      }
    }
    return wlist;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Create Measure',
          textAlign: TextAlign.center,
        ),
      ),
      body: new Container(
          alignment: Alignment.center,
          child: new GridView.count(
            primary: false,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(20.0),
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 1.0,
            crossAxisCount: 2 + _t.tuning.length,
            children: generateWidgets(),
          )),
    );
  }
}
