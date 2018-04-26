import 'package:flutter/material.dart';
import "dart:convert";
import "dart:io";
import 'group_page.dart';
import 'package:string_center_client/data/tab.dart';
import 'package:string_center_client/views/viewtab.dart';
import 'package:string_center_client/util/globals.dart' as globals;
import 'package:string_center_client/communications/servercommunication.dart';

///ViewTabList is a StatefulWidget that lists all tabs for a user to select to view or edit
class MyGroups extends StatefulWidget {
  @override
  _MyGroupsState createState() => new _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> {
  List<String> _groups = new List<String>();
  List<Widget> _wl = new List<Widget>();

  @override
  void initState() {
    _getGroupList().then((wl) {
      wl = _generateWidgets();
      setState(() {
        _wl = wl;
      });
    });
  }

  _getGroupList() async {
    var url = 'http://proj-309-ss-5.cs.iastate.edu:3000/api/get-groups-user-is-in';
    try {
      //send request
      String responseBody = await getRequestAuthorization(url);
      //decode reponse
      Map js = json.decode(responseBody);
      //populate list of tabs from json
      for (int i = 0; i < js['groupsByName'].length; i++) {
        _groups.add(js['groupsByName'][i]);
      }
    } catch (exception) {
      print('exception my groups');
    }
  }

  List<Widget> _generateWidgets() {
    List<Widget> wl = new List<Widget>();
    for (int i = 0; i < _groups.length; i++) {
      wl.add(new Container(
        decoration:
        new BoxDecoration(border: Border.all(color: globals.themeColor)),
        child: new MaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new GroupPage(_groups[i])));
          },
          child: new Text(_groups[i], softWrap: true),
        ),
      ));
      wl.add(new Padding(padding: new EdgeInsets.all(10.0)));
    }
    return wl;
  }

  @override
  Widget build(BuildContext context) {
    if (_wl == null) {
      return new Container();
    }
    print("widgets: " + _wl.toString());
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: globals.themeColor,
        title: new Text('My Groups'),
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