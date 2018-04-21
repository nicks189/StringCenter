import 'package:flutter/material.dart';
import 'package:ss_5/data/tab.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:ss_5/util/util.dart';
import 'home.dart';
import 'package:ss_5/communications/servercommunication.dart';
import 'package:ss_5/util/globals.dart' as globals;
import 'dart:convert';
class EditTab extends StatefulWidget {
  Tabb _t;
  EditTab(Tabb t){
    _t = t;
  }
  _EditTabState createState() =>
      new _EditTabState(_t);
}

class _EditTabState extends State<EditTab> {
  String _title;
  String _info;
  String _tuning;
  num index = 0;
  Tabb _t;
  Measure _m;
  int _noteCount;
  TextEditingController _noteController = new TextEditingController();
  TextEditingController _symbolController = new TextEditingController();
  FocusNode _noteFocus = new FocusNode();
  FocusNode _symbolFocus = new FocusNode();

  _EditTabState(Tabb t) {
    _t = t;
    _noteCount = _t.measures[0].strings[0].noteCount;
    _m = _t.measures[index];
    _noteController.text = _t.measures[0].strings[0].noteCount.toString();
  }

  void _newMeasure() {
    setState(() {
      _noteCount = int.parse(_noteController.text);
      _m = new Measure(_t.info, _t.tuning.length, _noteCount, _t.tuning);
    });
  }

  void _changeNote(int i, int j) {
    if (!(_symbolFocus.hasFocus) && !(_noteFocus.hasFocus)) {
      setState(() {
        if (j != null && i != null) {
          _m.strings[(1 + _t.tuning.length) - j].notes[i] =
              _symbolController.text;
        }
      });
    }
  }

  void _nextMeasure() {
    setState(() {
      _t.measures[index] = _m;
      index = _t.measures.length;
      _t.addMeasure(new Measure(_t.info, _t.tuning.length, _noteCount, _t.tuning));
      _m = _t.measures[index];
      new Measure(_t.info, _t.tuning.length, _noteCount, _t.tuning);
    });
  }

  void _viewNext() {
    setState(() {
      _t.measures[index] = _m;
      if(index < (_t.measures.length - 1)) {
        _m = _t.measures[index + 1];
        index++;
      }
    });
  }
  void _viewPrevious() {
    setState(() {
      _t.measures[index] = _m;
      if(index > 0) {
        _m = _t.measures[index - 1];
        index--;
      }
    });
  }

  _pushTab() async {
    _t.measures[index] = _m;
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/updateTab";
    var httpClient = new HttpClient();
    String result;
    Map m = new Map();
    m['tabID'] = _t.id;
    m['newTab'] = _t;
    var js = json.encode(m);
    print('test json'+js);
    try {
      var responseBody = await putRequestWriteAuthorization(url, js);
      print('BODY edittab pushtab: $responseBody');
      Map b = new Map();
      b = json.decode(responseBody);
      result = 'success';
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (BuildContext context) => new Home()),
              (Route<dynamic> route) => false);
    } catch (exception) {
      result = 'fail';
      print(exception);
    }
  }

  //returns a list of widgets that is used as children in this screen's
  List<Widget> generateWidgets() {
    List<Widget> wlist = [];

    //adds text field for entering the desired number of notes in the measure
    wlist.add(
      new TextField(
        controller: _noteController,
        focusNode: _noteFocus,
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

    //adds tuning labels on the left hand side
    wlist.add(new Text(''));
    for (int i = _t.tuning.length - 1; i >= 0; i--) {
      wlist.add(
        new Text(
          _t.tuning[i],
          textAlign: TextAlign.center,
        ),
      );
    }
    //blank space to skip the top row in column 2
    wlist.add(new Text(''));
    for (int i = 0; i < _noteCount; i++) {
      for (int j = 0; j < _t.tuning.length + 2; j++) {
        if (i == 1 && j == 0) {
          wlist.add(
            new TextField(
              controller: _symbolController,
              focusNode: _symbolFocus,
              maxLength: 2,
              maxLengthEnforced: true,
              onChanged: (_) {},
              decoration: new InputDecoration(
                hintText: 'symbol',
              ),
            ),
          );
          //skips top row
        } else if (j == 0 && i != 0) {
          wlist.add(new Text(''));
          //adds column labels
        } else if (j == 1) {
          wlist.add(new Text(
            i.toString(),
            textAlign: TextAlign.center,
          ));
          //adds note buttons
        } else if (!(i == 0 && j == 0)) {
          wlist.add(new MaterialButton(
              child: new Text(
                _m.strings[(1 + _t.tuning.length) - j].notes[i],
              ),
              onPressed: () {
                _changeNote(i, j);
              }));
        }
      }
    }
    return wlist;
  }

//build of CreateMeasure widget, provides UI for the CreateMeasure Widget
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: globals.themeColor,
        title: new Text(
          'Edit Tab',
          textAlign: TextAlign.center,
        ),
        actions: [
          new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                _viewPrevious();
              }),
          new IconButton(
              icon: new Icon(Icons.arrow_forward),
              onPressed: () {
                _viewNext();
              }),

          new IconButton(icon: new Icon(Icons.add), onPressed: _nextMeasure),
          new IconButton(
              icon: new Icon(Icons.file_upload), onPressed: _pushTab),
          new IconButton(
              icon: new Icon(Icons.home),
              onPressed: () {
                goHome(context);
              }),
        ],
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