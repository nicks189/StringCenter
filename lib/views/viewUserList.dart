import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:ss_5/util/globals.dart' as globals;
import 'package:ss_5/communications/servercommunication.dart';
import 'package:ss_5/data/group_object.dart';
import 'package:ss_5/views/create_post.dart';
import 'package:ss_5/util/util.dart';
import 'package:ss_5/data/user.dart';
import 'package:ss_5/views/viewUser.dart';

///GroupPage is a StatefulWidget that displays a group's page based on the
///groupname supplied as the parameter _givenGroupName to the Widget
class ViewUserList extends StatefulWidget {
  String _givenGroupName;

  ViewUserList(givenGroupName) {
    _givenGroupName = givenGroupName;
  }

  @override
  _ViewUserListState createState() => new _ViewUserListState(_givenGroupName);
}

class _ViewUserListState extends State<ViewUserList> {
  Group _group = new Group('','');
  String _groupName;
  List<Widget> _widgetList = new List<Widget>();
  List<User> _userList = new List<User>();

  _ViewUserListState(_givenGroupName) {
    _groupName = _givenGroupName;
  }

  _getPostList() async {
    var url =
        "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-group-members/$_groupName";
    try {
      //get userlist from group $groupName
      String responseBody = await getRequestAuthorization(url);
      print ("viewUserList responsebody getuserlist: " + responseBody.toString());
      Map users = json.decode(responseBody);
      //store group as group_object
      for (int i = 0; i < users['usernames'].length; i++) {
        _userList.add(new User(users['usernames'][i]));
      }
    } catch (exception) {
      print("viewUserList exception: " + exception.toString());
    }
  }

  @override
  void initState() {
    _getPostList().then((widgetList) {
      widgetList = _generateWidgets();
      setState(() {
        _widgetList = widgetList;
      });
    });
  }

  List<Widget> _generateWidgets() {
    List<Widget> widgetList = new List<Widget>();
    for (int i = 0; i < _userList.length; i++) {
      widgetList.add(new Container(
          decoration: new BoxDecoration(
              border: Border.all(color: globals.themeColor)
          ),
          child: new MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new ViewUser(_userList[i].username)));
              },
              child: new Row(
                children: <Widget>[
                  new Text(_userList[i].username),
                ],
              )

          )
      ));
      widgetList.add(new Padding(padding: new EdgeInsets.all(5.0)));
    }
    return widgetList;
  } //_generateWidgets

  @override
  Widget build(BuildContext context) {
    if (_widgetList == null) {
      return new Container(
          child: new Column(children: [
            new Text("Loading..."),
          ]));
    }
    var spacer = new SizedBox(height: 32.0);
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: globals.themeColor,
        title: new Text(_groupName),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Scaffold(
                          //TODO goto settings screen
                          body: new Text("settings screen stub"),
                        )));
              }),
          new IconButton(
              icon: new Icon(Icons.home),
              onPressed: () {
                goHome(context);
              }),
        ],
      ),
      body: new Container(
        padding: new EdgeInsets.all(12.0),
        child: new Center(
          child: new ListView(scrollDirection: Axis.vertical, children: _widgetList),
        ),
      ),
    );
  }
}
