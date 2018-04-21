import 'package:flutter/material.dart';
import 'package:ss_5/data/tab.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:ss_5/util/util.dart';
import 'home.dart';
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
  Tabb _t;
  Measure _m;
  int _noteCount;
  TextEditingController _noteController = new TextEditingController();
  TextEditingController _symbolController = new TextEditingController();
  FocusNode _noteFocus = new FocusNode();
  FocusNode _symbolFocus = new FocusNode();

  _EditTabState(Tabb t) {
    _t = t;
    _noteCount = 0;
    _noteController.text = '6';
    _symbolController.text = '8';
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
      _t.addMeasure(_m);
      _m = new Measure(_t.info, _t.tuning.length, _noteCount, _t.tuning);
    });
  }

  _pushTab() async {
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/updateTab";
    var httpClient = new HttpClient();
    String result;
    var js = json.encode(_t);
    print(js);
    try {
      var request = await httpClient.postUrl(Uri.parse(url));
      print(Uri.parse(url));
      request.headers.contentType = new ContentType("application", "json");
      request.write(js);
      var response = await request.close();
      var responseBody = await response.transform(UTF8.decoder).join();
      print('BODY: $responseBody');
      Map b = new Map();
      b = json.decode(responseBody);
      Tabb t = new Tabb.fromJson(b);
      print(t); // fields are the same, just no quotes
      //TODO (if success result = success)
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
        title: new Text(
          'Create Measure',
          textAlign: TextAlign.center,
        ),
        actions: [
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
    return new Scaffold();
  }
}