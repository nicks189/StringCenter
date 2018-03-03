import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'post.dart';
import 'user.dart';

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
    var url ="http://proj-309-ss-5.cs.iastate.edu:3000/api/follower/get-follower/$_user";

    for(int i = 0; i < 16;i++) { //TODO this is a STUB too
      _userList.add(new User());
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

    for (int i = 1; i < _userList.length; i++) { // TODO replace with userList or something
      widgetList.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new Scaffold(
          body: new Text("$i"),
        ))); //TODO viewPost instead of scaffold
      },
        child: new Text("Thing $i"), //TODO /*_postList[i].title*/ STUB
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