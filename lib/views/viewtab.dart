import 'package:flutter/material.dart';
import "dart:convert";
import "dart:io";
import 'package:ss_5/data/tab.dart';
import 'package:ss_5/util/globals.dart' as globals;
import 'edit_tab.dart';
import 'package:ss_5/util/util.dart';
import 'package:ss_5/communications/servercommunication.dart';


import 'package:ss_5/data/tab.dart';


///ViewTab is a StatelessWidget that displays a tab
///takes in a Tabb as a parameter [_t]
class ViewTab extends StatelessWidget {
  Tabb _t;
  ViewTab(Tabb t) {
    _t = t;
  }

  List<Tabb> tabs = new List<Tabb>();
  List<Widget> wl = new List<Widget>();

  _deleteTab() async {
    String _username = _t.toJson()["author_username"];
    String _tabID = _t.toJson()["_id"];
    Map js = new Map();
    try {
      String url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/deleteTab/$_tabID";
      String responseBody = await deleteRequestWriteAuthorization(
          url, json.encode(js));
      print('deleteTab on viewtab responsebody: ' + responseBody);
    } catch (exception) {
      print("viewtab deleteTab exception: " + exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if(globals.user.username == _t.toJson()['author_username'])
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('View Tab'),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.edit), onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(builder: (BuildContext context) => new EditTab(_t)),
                      (Route<dynamic> route) => false);
            }),
            new IconButton(icon: new Icon(Icons.delete), onPressed: () async {await _deleteTab();
            goHome(context);}),
          ],
        ),
        body: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Text(
              _t.render(),
              style: new TextStyle(fontSize: 22.0, fontFamily: 'monospace')
          ),
        ),
      );
    else
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('View Tab'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Text(
            _t.render(),
            style: new TextStyle(fontSize: 22.0, fontFamily: 'monospace')
        ),
      ),
    );
  }
}
