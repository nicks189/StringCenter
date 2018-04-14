import 'package:flutter/material.dart';
import 'util.dart';
import 'dart:convert';
import 'servercommunication.dart';
import 'dart:async';
import 'post.dart';
import 'view_post.dart';
import 'globals.dart' as globals;
import 'user.dart';

///ViewUser is a StatefulWidget that displays a user's page
///Takes in a [_givenUserName] in order to determine which user to display
class ViewUser extends StatefulWidget {
  String _givenUserName;

  ViewUser(String givenUserName) {
    _givenUserName = givenUserName;
  }

  @override
  _ViewUserState createState() => new _ViewUserState(_givenUserName);
}

class _ViewUserState extends State<ViewUser> {
  String _userName;
  User _user;
  bool _isFollowing;
  Image i = new Image.asset('einstein.jpg');
  List<Widget> _widgetList = new List<Widget>();
  List<Post> _postList = new List<Post>();

  _ViewUserState(String givenUserName) {
    _userName = givenUserName;
  }

  _getPostList() async {
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-post/by-user";
    try {
      //getting postlist
      String responseBody =
          await getRequestTokenAuthorization(url, globals.token);
      Map posts = json.decode(responseBody);
      //create current user object
      url =
          "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-user/info/$_userName";
      responseBody = await getRequestTokenAuthorization(url, globals.token);
      Map uInfo = json.decode(responseBody);
      _user = new User(uInfo['username'], uInfo['_id'], uInfo['description']);
      print("posts.length: " + posts['posts'].length.toString());
      for (int i = 0; i < posts['posts'].length; i++) {
        if (posts['posts'][i]["authorUsername"] == _userName)
          _postList.add(new Post(
              posts['posts'][i]["content"], posts['posts'][i]["tabId"]));
      }
    } catch (exception) {
      print("profilepage exception: " + exception.toString());
    }
  }

  @override
  void initState() {
    _getPostList().then((widgetList) {
      widgetList = _generateWidgets();
      _checkFollowing().then((isFollowing) {
        setState(() {
          _isFollowing = isFollowing;
          _widgetList = widgetList;
        });
      });
    });
  }

  List<Widget> _generateWidgets() {
    List<Widget> widgetList = new List<Widget>();
    widgetList.add(new Text(
      'About:',
      textAlign: TextAlign.left,
      style: new TextStyle(fontSize: 20.0),
    ));
    widgetList.add(
      new Container(
          margin: new EdgeInsets.all(12.0),
          padding: new EdgeInsets.all(12.0),
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.blue, width: 2.0),
            borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
          ),
          child: new Text(_user.description)),
    );
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
  }

  _follow() async {
    Map m = new Map();
    try {
      postRequestWriteAuthorization(
          'http://proj-309-ss-5.cs.iastate.edu:3000/api/follow-user/$_userName',
          json.encode(m));
    } catch (exception) {
      print('follow error' + exception.toString());
    }
    setState(() {
      _isFollowing = true;
    });
  }

  _unfollow() async {
    Map m = new Map();
    try {
      deleteRequestWriteAuthorization(
          'http://proj-309-ss-5.cs.iastate.edu:3000/api/unfollow-user/$_userName',
          json.encode(m));
    } catch (exception) {
      print('follow error' + exception.toString());
    }
    setState(() {
      _isFollowing = false;
    });
  }

  Future<List> _getFollowingList() async {
    List<String> userList = new List<String>();
    var url =
        "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-follower/following/${globals.user.username}";
    try {
      String responseBody = await getRequestAuthorization(url);
      Map js = json.decode(responseBody);
      print("decoded json map: " + js.toString());
      print("js['following'].length: " + js['following'].length.toString());
      for (int i = 0; i < js['following'].length; i++) {
        userList.add(js['following'][i]);
      }
    } catch (exception) {
      print("exception following");
    }
    return userList;
  }

  Future<bool>_checkFollowing() async {
    List<String> userList = await _getFollowingList();
    return userList.contains(_userName);
  }

  RaisedButton _generateFollowButton() {
    if (_isFollowing) {
      return new RaisedButton(
        onPressed: _unfollow,
        child: new Text('Unfollow'),
      );
    } else {
      return new RaisedButton(
        onPressed: _follow,
        child: new Text('Follow'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new Image.asset(
          'images/einstein.jpg',
          fit: BoxFit.scaleDown,
        ),
        title: new Text(_userName),
        actions: <Widget>[
          _generateFollowButton(),
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
