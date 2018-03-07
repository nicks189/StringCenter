import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'post.dart';
import 'user.dart';
import 'servercommunication.dart';
import 'dart:io';
import 'dart:convert';
class Followers extends StatefulWidget {
  String _givenUser;

  Followers(String givenUser) {
    _givenUser = givenUser;
  }

  @override
  _FollowersState createState() =>
      new _FollowersState(_givenUser);
}

class _FollowersState extends State<Followers> {
  String _user;
  bool _loaded = false;
  List<Widget> _widgetList = new List<Widget>();
  List<User> _userList = new List<User>();

  _FollowersState(String _givenUser) {
    _user = _givenUser;
  }

  _getFollowersList() async {
    var url ="http://proj-309-ss-5.cs.iastate.edu:3000/api/get-follower/followers/$_user";
    try {
      String responseBody = await getRequest(url);
      Map json = JSON.decode(responseBody);
      print("decoded json map: " + json.toString());
      print("json['followers'].length: " + json['followers'].length.toString());
      for (int i = 0; i < json['followers'].length; i++) {
        _userList.add(new User(json['followers'][i]));
      }
    } catch (exception) {
      print("exception followers");
    }

  }

  @override
  void initState() {
    _getFollowersList().then((widgetList) {
      widgetList = _generateWidgets();
      setState(() {
        _widgetList = widgetList;
      });
    });
  }




  List<Widget> _generateWidgets() {

    List<Widget> widgetList = new List<Widget>();

    for (int i = 0; i < _userList.length; i++) {
      widgetList.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new Scaffold(
          body: new Text(_userList[i].username)),
        ));
      },
        child: new Text(_userList[i].username),
      )
      );
    }
    return widgetList;
  } //_generateWidgets

  @override
  Widget build(BuildContext context) {
    if(_widgetList == null) {
      return new Container();
    }
    var spacer = new SizedBox(height: 32.0);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("$_user's Followers"),
        actions: <Widget>[
//          new IconButton(icon: new Icon(Icons.settings),
//              onPressed: () {
//                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new Scaffold( //TODO goto settings screen
//                  body: new Text("settings screen stub"),
//                )));
//              }),
        ],
      ),
      body: new Container(
        child: new Center(
          child: new ListView(scrollDirection: Axis.vertical ,children: _widgetList),
        ),
      ),
    );
  }
}