import 'package:flutter/material.dart';
import "dart:convert";
import "dart:io";

import 'package:ss_5/data/tab.dart';
import 'package:ss_5/views/viewtab.dart';
import 'package:ss_5/util/globals.dart' as globals;
import 'package:ss_5/communications/servercommunication.dart';

///ViewTabList is a StatefulWidget that lists all tabs for a user to select to view or edit
class ViewTabList extends StatefulWidget {
  @override
  _ViewTabListState createState() => new _ViewTabListState();
}

class _ViewTabListState extends State<ViewTabList> {
  bool _loaded = false;
  List<Tabb> _tabs = new List<Tabb>();
  List<Widget> _wl = new List<Widget>();

  @override
  void initState() {
    _getTabList().then((wl) {
      wl = _generateWidgets();
      setState(() {
        _wl = wl;
      });
    });
  }

  _getTabList() async {
    var url = 'http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/findTabsByUser';
    try {
      //send request
      String responseBody = await getRequestAuthorization(url);
      //decode reponse
      Map js = json.decode(responseBody);
      print("decoded json map: " + js.toString());
      print("js['tabs'].length: " + js['tabs'].length.toString());
      //populate list of tabs from json
      for (int i = 0; i < js['tabs'].length; i++) {
        _tabs.add(new Tabb.fromJson(js['tabs'][i]));
      }
    } catch (exception) {
      print('exception viewtablist');
    }
  }

  List<Widget> _generateWidgets() {
    List<Widget> wl = new List<Widget>();
    print("_tabs.length: " + _tabs.length.toString());
    for (int i = 0; i < _tabs.length; i++) {
      wl.add(new Container(
          decoration: new BoxDecoration(
              border: Border.all(color: globals.themeColor)
          ),
          child: new MaterialButton(
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new ViewTab(_tabs[i])));
        },
        child: new Text(_tabs[i].title, softWrap: true),
      )));
      wl.add(new Padding(padding: new EdgeInsets.all(10.0)));
    }
    return wl;
  }

  @override
  Widget build(BuildContext context) {
    if (_wl == null) {
      return new Container();
    }
    print("tabs: " + _tabs.toString());
    print("widgets: " + _wl.toString());
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: globals.themeColor,
        title: new Text('View Tab List'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new ListView(children: _wl),
        ),
      ),
    );
  }
}
