import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'dart:convert';
import 'servercommunication.dart';
import 'post.dart';


import 'globals.dart' as globals;

class ViewUser extends StatefulWidget {
  String _givenUserName;
  ViewUser(String givenUserName){
    _givenUserName = givenUserName;
  }
  @override
  _ViewUserState createState() =>
      new _ViewUserState(_givenUserName);
}

class _ViewUserState extends State<ViewUser> {
  String _userName;
  Image i = new Image.asset('einstein.jpg');
  List<Widget> _widgetList = new List<Widget>();
  List<Post> _postList = new List<Post>();
  _ViewUserState(String givenUserName) {
    _userName = givenUserName;
  }

  _getPostList() async {
    var url ="http://proj-309-ss-5.cs.iastate.edu:3000/api/get-post/by-user";
    try {
      String responseBody = await getRequestTokenAuthorization(url, globals.token);
      Map posts = json.decode(responseBody);

      print("posts.length: "+ posts['posts'].length.toString());
      for(int i = 0; i < posts['posts'].length; i++) {
        if(posts['posts'][i]["authorUsername"] == _userName)
        _postList.add(new Post(posts['posts'][i]["title"], posts['posts'][i]["content"]));
      }
    } catch(exception) {
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
    List<Widget> widgetList = new List<Widget>();
    widgetList.add(new Text('About Me:', textAlign: TextAlign.left, style: new TextStyle(fontSize: 20.0),));
    widgetList.add( new Container(
        margin: new EdgeInsets.all(12.0),
        padding: new EdgeInsets.all(12.0),
        decoration: new BoxDecoration(
          border: new Border.all(color: Colors.blue, width: 2.0),
          borderRadius: new BorderRadius.all(new Radius.circular(6.0)),

        ),
        child: new Text(globals.user.username)
    ),
    );
    widgetList.add(new Container(
      child: new MaterialButton(
          minWidth: 128.0,
          height: 32.0,
          child: new Text("Create Post", style: new TextStyle(color: Colors.white, fontSize: 16.0),),
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new Scaffold(
              body: new Text("Post Creation Screen"),
            )));
          }
      ),
      margin: new EdgeInsets.all(24.0),
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.red),
        borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
        color: Colors.red,
      ),
    ));
    for (int i = 0; i < _postList.length; i++) {
      widgetList.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new Scaffold(
          body: new Text(_postList[i].content),
        )));
      },
        child: new Text(_postList[i].content),
      )
      );
    }
    return widgetList;
  }

  _follow() {
    Map m = new Map();
    m['username'] = globals.user.username;
    m['followsUsername'] = _userName;
    try {
      postRequestWriteAuthorization('http://proj-309-ss-5.cs.iastate.edu:3000/api/follow-user/$_userName', json.encode(m));
    } catch (exception) {
      print('follow error' + exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      appBar: new AppBar(
        leading: new Image.asset('images/einstein.jpg', fit: BoxFit.scaleDown,),
        title: new Text(_userName),
        actions: <Widget>[
          new RaisedButton(onPressed: _follow, child: new Text('Follow'),),
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