import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'post.dart';
import 'servercommunication.dart';
import 'dart:convert';
import 'tab.dart';
import 'group_object.dart';
import 'user.dart';
import 'viewtab.dart';
import 'group_page.dart';
import 'viewUser.dart';
import 'home.dart';
import 'util.dart';
import 'view_post.dart';

/// Browse is a StatefulWidget that allows users to request a list of either Groups, Users, or Tabs
/// When a group is selected by the user, the app will route to GroupPage
/// When a user is selected by the user, the app will route to ViewUser
/// when a tab is selected by the user, the app will route to ViewTab
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
  Map<num, String> dropDownMap = {0: 'All', 1: 'Users', 2:'Groups', 3:'Tabs', 4:'Posts'};
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
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/search/$_search";

    try {
      String responseBody = await getRequestAuthorization(url);

    } catch (exception) {

    }
  }


  // _generateWidgets populates _widgetList with Widget's that are MaterialButtons
  // whose onPressed() routes to corresponding widgets (users, groups, tabs, posts)
  List<Widget> _generateWidgets() {
    List<Widget> widgetList = new List<Widget>();
    if(dropDownState == 0 || dropDownState == 1){ //users
      for (int i = 0; i < _userList.length; i++) {
        widgetList.add(new MaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new ViewUser(_userList[i].username)));
          },
          child: new Text(_userList[i].username),
        ));
      }
    }

    if(dropDownState == 0 || dropDownState == 2) { //groups
      for (int i = 0; i < _groupList.length; i++) {
        widgetList.add(new MaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new GroupPage(_groupList[i].groupName)));
          },
          child: new Text(_groupList[i].groupName),
        ));
      }
    }
    if(dropDownState == 0 || dropDownState == 3){ //tabs
      for (int i = 0; i < _tabList.length; i++) {
        widgetList.add(new MaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new ViewTab(_tabList[i])));
          },
          child: new Text(_tabList[i].title),
        ));
      }
    }
    if(dropDownState == 0 || dropDownState == 4){ //posts
      for (int i = 0; i < _postList.length; i++) {
        widgetList.add(new MaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new ViewPost(_postList[i])));
          },
          child: new Text(_postList[i].content, maxLines: 1),
        ));
      }
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
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new TextField(
                      controller: _search,
                      decoration: new InputDecoration(hintText: "Enter a search term"),
                    ),
                    new RaisedButton(
                      padding: new EdgeInsets.all(8.0),
                      child: new Text("Search"),
                      onPressed: () {
                        _getSearchList().then((wl) {
                          wl = _generateWidgets();
                          setState(() {
                            _widgetList = wl;
                          });
                        });
                      },
                    ),
                  ],
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
