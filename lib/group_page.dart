import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'post.dart';
import 'servercommunication.dart';
import 'dart:convert';
import 'group_object.dart';
import 'create_post.dart';
import 'view_post.dart';
import 'util.dart';

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
  Group _group;
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
      String responseBody = await getRequest(url);
      Map posts = json.decode(responseBody);
      //store group as group_object
      url =
          "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-group/$_groupName";
      responseBody = await getRequest(url);
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
              posts['posts'][i]["content"], posts['posts'][i]['tabId']));
        } else {
          _postList.add(new Post(posts['posts'][i]["content"]));
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
    if (_group.description != '') {
      widgetList.add(
        new Container(
            margin: new EdgeInsets.all(24.0),
            padding: new EdgeInsets.all(12.0),
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.blue, width: 2.0),
              borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
            ),
            child: new Text(_group.description)),
      );
    }

    widgetList.add(new Container(
      child: new MaterialButton(
          minWidth: 128.0,
          height: 32.0,
          child: new Text(
            "Create Post",
            style: new TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new CreatePost()));
          }),
      margin: new EdgeInsets.all(24.0),
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.red),
        borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
        color: Colors.red,
      ),
    ));
    for (int i = 0; i < _postList.length; i++) {
      widgetList.add(new MaterialButton(
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new ViewPost(_postList[i]),
              ));
        },
        child: new Text(_postList[i].content),
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
        title: new Text("GroupName"),
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
          child: new ListView(
              scrollDirection: Axis.vertical, children: _widgetList),
        ),
      ),
    );
  }
}
