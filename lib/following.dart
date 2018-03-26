import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'post.dart';
import 'user.dart';
import 'servercommunication.dart';
import 'dart:io';
import 'dart:convert';
import 'viewUser.dart';
import 'util.dart';
class Following extends StatefulWidget {
  String _givenUser;

  Following(String givenUser) {
    _givenUser = givenUser;
  }

  @override
  _FollowingState createState() =>
      new _FollowingState(_givenUser);
}

class _FollowingState extends State<Following> {
  String _user;
  bool _loaded = false;
  List<Widget> _widgetList = new List<Widget>();
  List<User> _userList = new List<User>();

  _FollowingState(String _givenUser) {
    _user = _givenUser;
  }

  _getFollowersList() async {
    var url ="http://proj-309-ss-5.cs.iastate.edu:3000/api/get-follower/following/$_user";
    try {
      String responseBody = await getRequestAuthorization(url);
      Map js = json.decode(responseBody);
      url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-user/all";
      responseBody = await getRequestAuthorization(url);
      Map js2 = json.decode(responseBody);
      print("decoded json map: " + js.toString());
      print("js['following'].length: " + js['following'].length.toString());
      for (int i = 0; i < js['following'].length; i++) {
        String tempU = js['following'][i];
        String tempU2 = "";
        for (int j = 0; j < js2['users'].length; j++) {
          if (tempU == js2['users'][j]) {
            tempU2 = tempU;
            break;
          }
        }
        _userList.add(new User(js['following'][i], tempU));
      }
    } catch (exception) {
      print("exception following");
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
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new ViewUser(_userList[i].username),
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
        title: new Text("$_user's Following"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.home), onPressed: () {goHome(context);}),
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