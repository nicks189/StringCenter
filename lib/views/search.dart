import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:ss_5/util/globals.dart' as globals;
import 'package:ss_5/data/post.dart';
import 'package:ss_5/communications/servercommunication.dart';
import 'package:ss_5/data/tab.dart';
import 'package:ss_5/data/group_object.dart';
import 'package:ss_5/data/user.dart';
import 'package:ss_5/views/viewtab.dart';
import 'package:ss_5/views/group_page.dart';
import 'package:ss_5/views/viewUser.dart';
import 'package:ss_5/views/home.dart';
import 'package:ss_5/util/util.dart';
import 'package:ss_5/views/view_post.dart';

/// Search is a StatefulWidget that allows users to request a list of either Groups,
/// Users, Posts, Tabs, or all of these,  based on a search keyword or keywords.
/// The user will enter a search phrase and choose All, Groups, Users, Posts, or Tabs
/// from a drop down menu in order to get a list of results that they are trying to search for.
/// When a group is selected by the user, the app will route to GroupPage.
/// When a user is selected by the user, the app will route to ViewUser.
/// When a tab is selected by the user, the app will route to ViewTab.
/// When a post is selected by the user, the app will route to ViewPost.
///
class Search extends StatefulWidget {
  @override
  _SearchState createState() => new _SearchState();
}

// State for Browse
class _SearchState extends State<Search> {
  //text field controller of search
  static final TextEditingController _search = new TextEditingController();
  //Map of dropdown menu
  Map<num, String> dropDownMap = {
    0: 'All',
    1: 'Users',
    2: 'Groups',
    3: 'Tabs',
    4: 'Posts'
  };
  // list of Widget's that will be displayed in a ListView. This will hold ViewTab's, ViewUser's, and GroupPage's
  List<Widget> _widgetList = new List<Widget>();

  // list of Tabb's that will be used to populate _widgetList
  List<Tabb> _tabList = new List<Tabb>();

  // list of Users that will be used to populate _widgetList
  List<User> _userList = new List<User>();

  // list of Groups that will be used to populate _widgetList
  List<Group> _groupList = new List<Group>();

  // list of Posts that will be used to populate _widgetList
  List<Post> _postList = new List<Post>();
  //state of the dropdown. 0 = all, 1 = users, 2 = groups, 3 = tabs, 4 = posts
  int dropDownState = 0;

  // _getSearchList is an async method that requests the server to return a json object that
  // contains all tabs in the database. This object is parsed to populate _tabList, _userList, _groupList, and _postList

  _getSearchList() async {
    var url =
        "http://proj-309-ss-5.cs.iastate.edu:3000/api/search/" + _search.text;

    try {
      String responseBody = await getRequestAuthorization(url);
      Map m = json.decode(responseBody);
      print("search searchterm: " + _search.text);
      print("search responsebody: " + responseBody.toString());
      for (int i = 0; i < m['users'].length; i++) {
        _userList.add(
            new User(m["users"][i]["username"], m["users"][i]["description"]));
      }
      for (int i = 0; i < m['groups'].length; i++) {
        _groupList.add(new Group(m["groups"][i]["groupName"]));
      }
      for (int i = 0; i < m['posts'].length; i++) {
        if (m['posts'][i]['tabId'] != null) {
          _postList.add(new Post(m['posts'][i]['authorUsername'],
              m['posts'][i]["content"], m['posts'][i]['tabId']));
        } else {
          _postList.add(new Post(
              m['posts'][i]['authorUsername'], m['posts'][i]["content"]));
        }
      }
      for (int i = 0; i < m['tabs'].length; i++) {
        _tabList.add(new Tabb.fromJson(m['tabs'][i]));
      }
    } catch (exception) {
      print("search exception: " + exception.toString());
    }
  }

  // _generateWidgets populates _widgetList with Widget's that are MaterialButtons
  // whose onPressed() routes to corresponding widgets (users, groups, tabs, posts)
  List<Widget> _generateWidgets() {
    List<Widget> widgetList = new List<Widget>();
    if (dropDownState == 0 || dropDownState == 1) {
      //users
      for (int i = 0; i < _userList.length; i++) {
        widgetList.add(new Container(
          padding: new EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          child: new MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new ViewUser(_userList[i].username)));
            },
            child: new Container(
              decoration: new BoxDecoration(
                  border: Border.all(color: globals.themeColor)),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Container(
                        decoration: new BoxDecoration(
                          border: new Border(
                            right: new BorderSide(color: globals.themeColor),
                            bottom: new BorderSide(color: globals.themeColor),
                          ),
                        ),
                        child:new Text("User"),
                      ),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(_userList[i].username),
                      new Text("\n"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    }

    if (dropDownState == 0 || dropDownState == 2) {
      //groups
      for (int i = 0; i < _groupList.length; i++) {
        widgetList.add(new Container(
          padding: new EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          child: new MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new GroupPage(_groupList[i])));
            },
            child: new Container(
              decoration: new BoxDecoration(
                  border: Border.all(color: globals.themeColor)),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Container(
                        decoration: new BoxDecoration(
                          border: new Border(
                            right: new BorderSide(color: globals.themeColor),
                            bottom: new BorderSide(color: globals.themeColor),
                          ),
                        ),
                        child:new Text("Group"),
                      ),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(_groupList[i].groupName),
                      new Text("\n"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    }
    if (dropDownState == 0 || dropDownState == 3) {
      //tabs
      for (int i = 0; i < _tabList.length; i++) {
        widgetList.add(new Container(
          padding: new EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          child: new MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new ViewTab(_tabList[i])));
            },
            child: new Container(
              decoration: new BoxDecoration(
                  border: Border.all(color: globals.themeColor)),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Container(
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(color: globals.themeColor),
                                bottom: new BorderSide(color: globals.themeColor),
                            ),
                        ),
                        child:new Text("Tab"),
                    ),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(_tabList[i].title),
                      new Text("\n"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    }
    if (dropDownState == 0 || dropDownState == 4) {
      //posts
      for (int i = 0; i < _postList.length; i++) {
        widgetList.add(new Container(
          padding: new EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          child: new MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new ViewPost(_postList[i])));
            },
            child: new Container(
              decoration: new BoxDecoration(
                  border: Border.all(color: globals.themeColor)),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Container(
                        decoration: new BoxDecoration(
                          border: new Border(
                            right: new BorderSide(color: globals.themeColor),
                            bottom: new BorderSide(color: globals.themeColor),
                          ),
                        ),
                        child:new Text("Post"),
                      ),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(_postList[i].content),
                      new Text("\n"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: globals.themeColor,
        title: new Text("Search"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.home),
              onPressed: () {
                goHome(context);
              }),
        ],
      ),
      body: new Container(
        child: new Center(
            child: new Column(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.all(55.0),
              child: new TextField(
                controller: _search,
                decoration:
                    new InputDecoration(hintText: "Enter a search term"),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new DropdownButton<String>(
                  value: dropDownMap[dropDownState],
                  hint: new Text('Pick a search filter'),
                  items: [
                    new DropdownMenuItem(
                      value: dropDownMap[0],
                      child: new Text(dropDownMap[0]),
                    ),
                    new DropdownMenuItem(
                      value: dropDownMap[1],
                      child: new Text(dropDownMap[1]),
                    ),
                    new DropdownMenuItem(
                      value: dropDownMap[2],
                      child: new Text(dropDownMap[2]),
                    ),
                    new DropdownMenuItem(
                      value: dropDownMap[3],
                      child: new Text(dropDownMap[3]),
                    ),
                    new DropdownMenuItem(
                      value: dropDownMap[4],
                      child: new Text(dropDownMap[4]),
                    ),
                  ],
                  onChanged: (_value) {
                    if (_value == dropDownMap[0]) {
                      dropDownState = 0;
                      print(dropDownState.toString());
                      setState(() {});
                    } else if (_value == dropDownMap[1]) {
                      dropDownState = 1;
                      print(dropDownState.toString());
                      setState(() {});
                    } else if (_value == dropDownMap[2]) {
                      dropDownState = 2;
                      print(dropDownState.toString());
                      setState(() {});
                    } else if (_value == dropDownMap[3]) {
                      dropDownState = 3;
                      print(dropDownState.toString());
                      setState(() {});
                    } else if (_value == dropDownMap[4]) {
                      dropDownState = 4;
                      print(dropDownState.toString());
                      setState(() {});
                    }
                  }, //onChanged
                ),
                new RaisedButton(
                  padding: new EdgeInsets.all(8.0),
                  child: new Text("Search"),
                  onPressed: () {
                    if (_search.text.isNotEmpty) {
                      _postList.removeRange(0, _postList.length);
                      _userList.removeRange(0, _userList.length);
                      _tabList.removeRange(0, _tabList.length);
                      _groupList.removeRange(0, _groupList.length);
                      _getSearchList().then((wl) {
                        wl = _generateWidgets();
                        setState(() {
                          _widgetList = wl;
                        });
                      });
                    }
                  },
                ),
              ],
            ),
            new Padding(padding: new EdgeInsets.all(8.0)),
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
