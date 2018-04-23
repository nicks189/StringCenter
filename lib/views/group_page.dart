import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

import 'package:ss_5/util/globals.dart' as globals;
import 'package:ss_5/data/post.dart';
import 'package:ss_5/communications/servercommunication.dart';
import 'package:ss_5/data/group_object.dart';
import 'package:ss_5/views/create_post.dart';
import 'package:ss_5/views/view_post.dart';
import 'package:ss_5/util/util.dart';
import 'package:ss_5/views/viewUserList.dart';
import 'package:ss_5/data/tab.dart';

///GroupPage is a StatefulWidget that displays a group's page based on the
///groupname supplied as the parameter _givenGroupName to the Widget
class GroupPage extends StatefulWidget {
  String _givenGroupName;

  GroupPage(givenGroupName) {
    _givenGroupName = givenGroupName;
  }

  @override
  _GroupPageState createState() => new _GroupPageState(_givenGroupName);
}

class _GroupPageState extends State<GroupPage> {
  Group _group = new Group('', '');
  String _groupName;
  List<Widget> _widgetList = new List<Widget>();
  List<Post> _postList = new List<Post>();
  double textBoxWidth = 128.0;
  bool _isInGroup;
  _GroupPageState(_givenGroupName) {
    _groupName = _givenGroupName;
  }

  double _textBoxWidth(bool hasTab) {
    if (hasTab) return 128.0;
    else return 312.0;
  }
  
  _getPostList() async {
    var url =
        "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-group-posts/$_groupName";
    try {
      //get postlist from group $groupName
      Map m = {"groupName": "$_groupName"};
      String js = json.encode(m);
      String responseBody = await getRequestAuthorization(url);
      print("group_page responsebody getpostlist: " + responseBody.toString());
      Map posts = json.decode(responseBody);
      //store group as group_object
      url =
          "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-group/$_groupName";
      responseBody = await getRequestAuthorization(url);
      Map m2 = json.decode(responseBody);
      print("group page get group: " + responseBody);
      if (m2['group']['description'] != null) {
        _group = new Group(_groupName, m2['group']['description']);
      } else {
        _group = new Group(_groupName);
      }
      print("posts.length: " + posts['posts'].length.toString());
      for (int i = 0; i < posts['posts'].length; i++) {
        if (posts['posts'][i]['tabId'] != null) {
          _postList.add(new Post(posts['posts'][i]['authorUsername'],
              posts['posts'][i]["content"],
              posts['posts'][i]['tabId'],
              posts['posts'][i]['groupName'],
              Tabb.fromJson(posts['posts'][i]['tab'])));
        } else {
          _postList.add(new Post(posts['posts'][i]['authorUsername'], posts['posts'][i]["content"], '',
              posts['posts'][i]['groupName']));
        }
      }
    } catch (exception) {
      print("grouppage exception: " + exception.toString());
    }
  }

  Future<List> _getGroupMembers() async {
    List<String> userList = new List<String>();
    var url =
        "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-group-members/$_groupName";
    try {
      String responseBody = await getRequestAuthorization(url);
      Map js = json.decode(responseBody);
      print("decoded json map: " + js.toString());
      print("js['usernames'].length: " + js['usernames'].length.toString());
      for (int i = 0; i < js['usernames'].length; i++) {
        userList.add(js['usernames'][i]);
      }
    } catch (exception) {
      print("exception getGroupMembers" + exception.toString());
    }
    return userList;
  }

  Future<bool>_checkIsInGroup() async {
    List<String> userList = await _getGroupMembers();
    return userList.contains(globals.user.username);
  }

  _joinGroup() async {
    Map m = new Map();
    try {
      putRequestAuthorization(
          'http://proj-309-ss-5.cs.iastate.edu:3000/api/join-group/$_groupName');
    } catch (exception) {
      print('follow error' + exception.toString());
    }
    setState(() {
      _isInGroup = true;
    });
  }

  _leaveGroup() async {
    Map m = new Map();
    try {
      deleteRequestWriteAuthorization(
          'http://proj-309-ss-5.cs.iastate.edu:3000/api/leave-group/$_groupName',
          json.encode(m));
    } catch (exception) {
      print('follow error' + exception.toString());
    }
    setState(() {
      _isInGroup = false;
    });
  }

  @override
  void initState() {
    _getPostList().then((widgetList) {
      widgetList = _generateWidgets();
      _checkIsInGroup().then((isInGroup) {
        setState(() {
          _isInGroup = isInGroup;
          _widgetList = widgetList;
        });
      });
    });
  }

  RaisedButton _generateJoinButton() {
    if (_isInGroup) {
      return new RaisedButton(
        onPressed: _leaveGroup,
        child: new Text('Leave'),
      );
    } else {
      return new RaisedButton(
        onPressed: _joinGroup,
        child: new Text('Join'),
      );
    }
  }

  List<Widget> _generateWidgets() {
    List<Widget> widgetList = new List<Widget>();
    for (int i = 0; i < _postList.length; i++) {
      widgetList.add(new Container(
        margin: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
          decoration:
              new BoxDecoration(border: Border.all(color: globals.themeColor)),
          constraints: new BoxConstraints(maxWidth: 128.0, maxHeight: 168.0),
          child: new MaterialButton(
            padding: new EdgeInsets.all(0.0),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new ViewPost(_postList[i])));
              },
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        constraints: new BoxConstraints(maxWidth: 100.0, maxHeight: 32.0),
                        padding: new EdgeInsets.all(6.0),
                        margin: new EdgeInsets.fromLTRB(0.0, 0.0, 18.0, 4.0),
                        child: new Text(_postList[i].authorUsername),
                        decoration: new BoxDecoration(border: new Border(
                          right: new BorderSide(color: globals.themeColor),
                          bottom: new BorderSide(color: globals.themeColor),
                        ),
                        ),
                      ),
                      new Container(
                        constraints: new BoxConstraints(maxWidth: _textBoxWidth(_postList[i].hasTab), maxHeight: 196.0),
                        margin: new EdgeInsets.fromLTRB(12.0, 2.0, 18.0, 6.0),
                        padding: new EdgeInsets.all(4.0),
                        child: new Text(_postList[i].content, maxLines: 6),
                        decoration: new BoxDecoration(
                          border: new Border.all(color: globals.themeColor),
                        ),
                      ),
                    ],
                  ),
                  new Text(_postList[i].tabRender()),
                ],
              ),
          ),
      ),
      );
    }
    return widgetList;
  } //_generateWidgets

  @override
  Widget build(BuildContext context) {
    if (_widgetList == null || _isInGroup == null) {
      return new Container();
    }
    var spacer = new SizedBox(height: 32.0);
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: globals.themeColor,
        title: new Text(_groupName),
        actions: <Widget>[
          _generateJoinButton(),
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
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Container(
                  margin: new EdgeInsets.all(24.0),
                  padding: new EdgeInsets.all(10.0),
                  width: 400.0,
                  decoration: new BoxDecoration(
                    border:
                        new Border.all(color: globals.themeColor, width: 2.0),
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(6.0)),
                  ),
                  child: new Text(_group.description)),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child: new MaterialButton(
                        minWidth: 128.0,
                        height: 32.0,
                        child: new Text(
                          "Group Members",
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new ViewUserList(_groupName)));
                        }),
                    margin: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                    decoration: new BoxDecoration(
                      border: new Border.all(color: globals.themeColor),
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(6.0)),
                      color: globals.themeColor,
                    ),
                  ),
                  new Container(
                    child: new MaterialButton(
                        minWidth: 128.0,
                        height: 32.0,
                        child: new Text(
                          "Create Post",
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new CreatePost('', _groupName, null)));
                        }),
                    margin: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                    decoration: new BoxDecoration(
                      border: new Border.all(color: globals.themeColor),
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(6.0)),
                      color: globals.themeColor,
                    ),
                  ),
                ],
              ),
              new Expanded(
                child: new ListView(
                    scrollDirection: Axis.vertical, children: _widgetList),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
