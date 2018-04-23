import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:ss_5/data/user.dart';
import 'package:flutter/services.dart';
import 'package:ss_5/communications/servercommunication.dart';
import 'package:ss_5/data/tab.dart';
import 'package:ss_5/data/post.dart';
import 'package:ss_5/util/globals.dart' as globals;

///ViewPost is a StatefulWidget that displays Post's
class ViewPost extends StatefulWidget {
  Post _givenPost;

  ViewPost(Post givenPost) {
    _givenPost = givenPost;
  }

  @override
  _ViewPostState createState() => new _ViewPostState(_givenPost);
}

class _ViewPostState extends State<ViewPost> {
  Post _post;
  Tabb _t;
  User u;

  _ViewPostState(Post givenPost) {
    _post = givenPost;
  }

  @override
  void initState() {
    _getTab().then((_){
      _getUser().then((_) {
        setState(() {});
      });
      });
  }

  _getUser() async {
    try {
      String response = await getRequestAuthorization(
          "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-user/info/${_post.authorUsername}");
      Map m = json.decode(response);
      print(m);
      u = new User(m['username'], m['profilePic']);
    } catch (exception) {
      print('view post get user exception' + exception.toString());
    }
  }

  _getTab() async {
    try {
      String response = await getRequestAuthorization(
          "http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/findTabById/${_post
              .tabID}");
      _t = new Tabb.fromJson(json.decode(response));
    } catch (exception) {
      print('get tab by id exception' + exception.toString());
    }
  }

  Widget _showTab() {
    if (_t != null) {
      return new Text(_t.render(),
          style: new TextStyle(fontSize: 22.0, fontFamily: 'monospace'));
    } else
      return new Text('');
  }

  @override
  Widget build(BuildContext context) {
    if(u == null){
      return new Container();
    }else
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: globals.themeColor,
        leading: new Image.network(
          'http://proj-309-ss-5.cs.iastate.edu:3000/${u.profilePic}',
          fit: BoxFit.fill,
        ),
        title: new Text(_post.authorUsername),
      ),
      body: new Container(
        alignment: Alignment.center,
        padding: new EdgeInsets.all(20.0),
        child: new ListView(
          children: <Widget>[
            new Container(
                margin: new EdgeInsets.all(24.0),
                padding: new EdgeInsets.all(10.0),
                width: 400.0,
                decoration: new BoxDecoration(
                    border: Border.all(color: globals.themeColor)
                ),
                child: new Text(_post.content),
                ),
                _showTab(),
          ],
        ),
      ),
    );
  }
}
