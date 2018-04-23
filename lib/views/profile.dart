import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:ss_5/communications/servercommunication.dart';
import 'package:ss_5/data/post.dart';
import 'package:ss_5/util/util.dart';
import 'package:ss_5/views/followers.dart';
import 'package:ss_5/views/following.dart';
import 'package:ss_5/views/home.dart';
import 'package:ss_5/views/create_post.dart';
import 'package:ss_5/views/edit_profile.dart';
import 'package:ss_5/views/view_post.dart';
import 'package:ss_5/util/globals.dart' as globals;
import 'package:ss_5/data/tab.dart';
///Profile is a StatefulWidget that is the profile page for the user
///that is currently logged in.
class Profile extends StatefulWidget {
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  Image i = new Image.asset('einstein.jpg');
  List<Widget> _widgetList = new List<Widget>();
  List<Post> _postList = new List<Post>();

  double _textBoxWidth(bool hasTab) {
    if (hasTab) return 128.0;
    else return 312.0;
  }


  _getPostList() async {
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-post/by-user/current";
    try {
      String responseBody =
          await getRequestTokenAuthorization(url, globals.token);
      Map posts = json.decode(responseBody);

      if (posts['posts'] != null) {
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
      }
    } catch (exception) {
      print("profilepage exception: " + exception.toString());
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
    print(globals.user.description);
    List<Widget> widgetList = new List<Widget>();
    widgetList.add(new Row(
        children: <Widget>[
          new Text(
          'About Me:',
          textAlign: TextAlign.left,
         style: new TextStyle(fontSize: 20.0),
         ),
          new Padding(padding: new EdgeInsets.only(right: 25.0)),
          new RaisedButton(
            color: globals.themeColor,
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new Followers(globals.user.username)));
            },
            child: new Text('Followers'), textColor: Colors.white,),
          new Padding(padding: new EdgeInsets.only(right: 15.0)),
          new RaisedButton(
            color: globals.themeColor,
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new Following(globals.user.username)));
            },
            child: new Text('Following'), textColor: Colors.white,),
        ]
    ));
    widgetList.add(
      new Container(
          margin: new EdgeInsets.all(12.0),
          padding: new EdgeInsets.all(12.0),
          decoration: new BoxDecoration(
            border: new Border.all(color: globals.themeColor, width: 2.0),
            borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
          ),
          child: new Text(globals.user.description)),
    );
    widgetList.add(new Container(
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
                    builder: (BuildContext context) => new CreatePost()));
          }),
      margin: new EdgeInsets.all(24.0),
      decoration: new BoxDecoration(
        border: new Border.all(color: globals.themeColor),
        borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
        color: globals.themeColor,
      ),
    ));
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
  }

  _editProfile() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new EditProfile()));
  }

  @override
  Widget build(BuildContext context) {
    print(globals.user.profilePic);
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: globals.themeColor,
        leading: new Image.network(
          'http://proj-309-ss-5.cs.iastate.edu:3000/${globals.user.profilePic}',
          fit: BoxFit.fill,
        ),
        title: new Text(globals.user.username),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.settings), onPressed: _editProfile),
          new IconButton(
              icon: new Icon(Icons.home),
              onPressed: () {
                goHome(context);
              }),
        ],
      ),
      body: new Container(
        alignment: Alignment.center,
        padding: new EdgeInsets.all(20.0),
        child: new ListView(
          children: _widgetList,
        ),
      ),
    );
  }
}
