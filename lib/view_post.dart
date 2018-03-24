import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'dart:convert';
import 'servercommunication.dart';
import 'post.dart';


import 'globals.dart' as globals;

class ViewPost extends StatefulWidget {
  Post _givenPost;
  ViewPost(Post givenPost){
    _givenPost = givenPost;
  }
  @override
  _ViewPostState createState() =>
      new _ViewPostState(_givenPost);
}

class _ViewPostState extends State<ViewPost> {
  Post _post;
  Image i = new Image.asset('einstein.jpg');
  List<Widget> _widgetList = new List<Widget>();
  List<Post> _postList = new List<Post>();
  _ViewPostState(Post givenPost) {
    _post = givenPost;
  }

  _generateWidgets() {

  }

  @override
  void initState() {
    _generateWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new Image.asset('images/einstein.jpg', fit: BoxFit.scaleDown,),
        title: new Text(_post.authorUsername),
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