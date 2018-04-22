import 'package:flutter/material.dart';
import 'dart:convert';

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
  Group _group = new Group('','');
  String _groupName;
  List<Widget> _widgetList = new List<Widget>();
  List<Post> _postList = new List<Post>();

  _GroupPageState(_givenGroupName) {
    _groupName = _givenGroupName;
  }

  _getPostList() async {
    var url =
        "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-group-posts/$_groupName";
    try {
      //get postlist from group $groupName
      Map m = {"groupName": "$_groupName"};
      String js = json.encode(m);
      String responseBody = await getRequestAuthorization(url);
      print ("group_page responsebody getpostlist: " + responseBody.toString());
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
          _postList.add(new Post(
              posts['posts'][i]["content"], posts['posts'][i]['tabId'], posts['posts'][i]['groupName'], Tabb.fromJson(posts['posts'][i]['tab'])));
        } else {
          _postList.add(new Post(posts['posts'][i]["content"],'',posts['posts'][i]['groupName']));
        }
      }
    } catch (exception) {
      print("grouppage exception: " + exception.toString());
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
    for (int i = 0; i < _postList.length; i++) {
      widgetList.add(new Container(
        margin: EdgeInsets.all(12.0),
          decoration: new BoxDecoration(
              border: Border.all(color: globals.themeColor)
          ),
          child: new MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new ViewPost(_postList[i])));
              },
              child: new Row(
                children: <Widget>[
                  new Container(
                   constraints: new BoxConstraints(),
                    padding: new EdgeInsets.fromLTRB(0.0,0.0,12.0,0.0),
                    child: new Text(_postList[i].content,style: new TextStyle(fontSize: 12.0))),
                  new Text(_postList[i].tabRender()),
                  /*new IconButton(icon: new Icon(Icons.zoom_in), onPressed: null)*/
                ],
              )

          )
      ));
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
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Container(
                  margin: new EdgeInsets.all(24.0),
                  padding: new EdgeInsets.all(10.0),
                  width: 400.0,
                  decoration: new BoxDecoration(
                    border: new Border.all(color: globals.themeColor, width: 2.0),
                    borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                  ),
                  child: new Text(_group.description)
              ),
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
                                builder: (BuildContext context) => new ViewUserList(_groupName)));
                      }),
                  margin: new EdgeInsets.fromLTRB(10.0,0.0,10.0,20.0),
                  decoration: new BoxDecoration(
                    border: new Border.all(color: globals.themeColor),
                    borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
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
                                builder: (BuildContext context) => new CreatePost('', _groupName, null)));
                      }),
                  margin: new EdgeInsets.fromLTRB(10.0,0.0,10.0,20.0),
                  decoration: new BoxDecoration(
                    border: new Border.all(color: globals.themeColor),
                    borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                    color: globals.themeColor,
                  ),
                ),
              ],
              ),
              new Expanded(child: new ListView(scrollDirection: Axis.vertical, children: _widgetList),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
