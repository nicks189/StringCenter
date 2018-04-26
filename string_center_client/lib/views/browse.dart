import 'package:flutter/material.dart';
import 'package:string_center_client/util/globals.dart' as globals;
import 'package:string_center_client/data/post.dart';
import 'package:string_center_client/communications/servercommunication.dart';
import 'dart:convert';
import 'package:string_center_client/data/tab.dart';
import 'package:string_center_client/data/group_object.dart';
import 'package:string_center_client/data/user.dart';
import 'package:string_center_client/views/viewtab.dart';
import 'package:string_center_client/views/group_page.dart';
import 'package:string_center_client/views/viewUser.dart';
import 'package:string_center_client/views/home.dart';
import 'package:string_center_client/util/util.dart';

/// Browse is a StatefulWidget that allows users to request a list of either Groups, Users, or Tabs
/// When a group is selected by the user, the app will route to GroupPage
/// When a user is selected by the user, the app will route to ViewUser
/// when a tab is selected by the user, the app will route to ViewTab
///
class Browse extends StatefulWidget {
  @override
  _BrowseState createState() => new _BrowseState();
}

// State for Browse
class _BrowseState extends State<Browse> {
  // list of Widget's that will be displayed in a ListView. This will hold ViewTab's, ViewUser's, and GroupPage's
  List<Widget> _widgetList = new List<Widget>();

  // list of Tabb's that will be used to populate _widgetList
  List<Tabb> _tabList = new List<Tabb>();

  // list of Users that will be used to populate _widgetList
  List<User> _userList = new List<User>();

  // list of Groups that will be used to populate _widgetList
  List<Group> _groupList = new List<Group>();

  // _getTabList is an async method that requests the server to return a json object that
  // contains all tabs in the database. This object is parsed to populate _tabList

  _getTabList() async {
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/";
    try {
      //send request
      String responseBody = await getRequestAuthorization(url);
      //decode reponse
      Map js = json.decode(responseBody);
      print("decoded json map: (browse) " + js.toString());
      print("js['tabs'].length: (browse) " + js['tabs'].length.toString());
      //populate list of tabs from json
      _tabList.removeRange(0, _tabList.length);

      for (int i = 0; i < js['tabs'].length; i++) {
        _tabList.add(new Tabb.fromJson(js['tabs'][i]));
      }
    } catch (exception) {
      print("browse gettablist exception: " + exception.toString());
    }
  }

  // _getGroupList is an async method that requests the server to return a json object that
  // contains all groups in the database. This object is parsed to populate _groupList
  _getGroupList() async {
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-groups";
    try {
      String responseBody = await getRequestAuthorization(url);
      Map groups = json.decode(responseBody);
      print("groups.length (browse) : " +
          groups["groupsByName"].length.toString());
      // populate group list with new group objects parsed from server
      _groupList.removeRange(0, _groupList.length);
      for (int i = 0; i < groups["groupsByName"].length; i++) {
        _groupList.add(new Group(groups["groupsByName"][i]));
      }
    } catch (exception) {
      print("browse getgrouplist exception: " + exception.toString());
    }
  }

  /// getUserList is an async method that requests the server to return a json object that
  /// contains all user in the database. This object is parsed to populate _userList
  _getUserList() async {
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-user/all";
    try {
      String responseBody = await getRequestAuthorization(url);
      Map users = json.decode(responseBody);
      _userList.removeRange(0, _userList.length);
      for (int i = 0; i < users["users"].length; i++) {
        _userList.add(new User(
            users["users"][i]["username"], users["users"][i]["description"]));
      }
    } catch (exception) {
      print("browse getuserlist exception: " + exception.toString());
    }
  }

  // _genTabWidgets populates _widgetList with Widget's that are MaterialButtons
  // whose onPressed() routes to ViewTab's that view Tabbs from _tabList onPressed
  List<Widget> _genTabWidgets() {
    List<Widget> widgetList = new List<Widget>();
    for (int i = 0; i < _tabList.length; i++) {
      widgetList.add(new Container(
        decoration: new BoxDecoration(
          border: Border.all(color: globals.themeColor)
        ),
        child: new MaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new ViewTab(_tabList[i])));
          },
        child: new Text(_tabList[i].title, softWrap: true)
      )));
      widgetList.add(new Padding(padding: new EdgeInsets.all(10.0)));
    }
    return widgetList;
  }

  // _genGroupWidgets populates _widgetList with widget's that are MaterialButtons
  // whose onPressed() routes to GroupPage's that are in _groupList
  List<Widget> _genGroupWidgets() {
    List<Widget> widgetList = new List<Widget>();
    for (int i = 0; i < _groupList.length; i++) {
      print(_groupList[i].groupName);
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
                            new GroupPage(_groupList[i].groupName)));
              },
              child: new Text(_groupList[i].groupName, softWrap: true)
          )));
      widgetList.add(new Padding(padding: new EdgeInsets.all(10.0)));
    }
    return widgetList;
  }

  // _genUserWidgets populates _widgetList with Widget's that are MaterialButtons
  // whose onPressed() routes to ViewUser's that are in _userList
  List<Widget> _genUserWidgets() {
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
              child: new Text(_userList[i].username, softWrap: true)
          )));
      widgetList.add(new Padding(padding: new EdgeInsets.all(10.0)));
    }
    return widgetList;
  }

//build of Browse Widget, provides UI for the Browse Widget
  //Has an AppBar
  //Has a Row of three RaisedButtons with titles Tabs, Groups, and Users,
  // whose onPressed() call
  // _getTabList and _genTabWidgets,
  // _getGroupList and _genGroupWidgets,
  // _getUserList and _genUserWidgets, respectively
  //Has a ListView wrapped by an Expanded
  // the ListView displays the current state of _widgetList
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Browse"),
        backgroundColor: globals.themeColor,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.home),
              onPressed: () {
                goHome(context);
              }),
        ],
      ),
      body: new Container(
        padding: new EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
        child: new Center(
            child: new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.all(12.0)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new RaisedButton(
                  padding: new EdgeInsets.all(8.0),
                  child: new Text("Tabs"),
                  onPressed: () {
                    _getTabList().then((wl) {
                      wl = _genTabWidgets();
                      setState(() {
                        _widgetList = wl;
                      });
                    });
                  },
                ),
                new RaisedButton(
                  padding: new EdgeInsets.all(8.0),
                  child: new Text("Groups"),
                  onPressed: () {
                    _getGroupList().then((wl) {
                      wl = _genGroupWidgets();
                      setState(() {
                        _widgetList = wl;
                      });
                    });
                  },
                ),
                new RaisedButton(
                  padding: new EdgeInsets.all(8.0),
                  child: new Text("Users"),
                  onPressed: () {
                    _getUserList().then((wl) {
                      wl = _genUserWidgets();
                      setState(() {
                        _widgetList = wl;
                      });
                    });
                  },
                ),
              ],
            ),
            new Padding(
              padding: new EdgeInsets.all(10.0)
            ),
            new Expanded(
              child: new ListView(
                  scrollDirection: Axis.vertical, children: _widgetList),
            ),
          ],
        )),
      ),
    );
  }
}
