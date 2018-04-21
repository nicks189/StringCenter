import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:ss_5/data/tab.dart';
import 'selectTab.dart';
import 'package:ss_5/data/post.dart';
import 'package:ss_5/communications/servercommunication.dart';
import 'package:ss_5/views/home.dart';
import 'package:ss_5/util/util.dart';

/// CreatePost is a StatefulWidget that allows a user to create a Post which may
/// or may not contain a Tabb object, and may or may not contain a text field
class CreatePost extends StatefulWidget {
  Tabb _t;
  String _s;
  String _groupName;

  CreatePost([Tabb t, String s, String groupName]) {
    _t = t;
    _s = s;
    _groupName = groupName;
  }

  @override
  _CreatePostState createState() => new _CreatePostState(_t, _s, _groupName);
}

// State for CreatePost
class _CreatePostState extends State<CreatePost> {
  Tabb _t;
  String _s;
  String _groupName;
  TextEditingController _ptc = new TextEditingController();

  _CreatePostState([Tabb t, String s = '', String groupName = '']) {
    _t = t;
    _s = s;
    _ptc.text = s;
    _groupName = groupName;
  }

  _finalizePost() async {
    Post p;
    if (_t != null) {
      p = new Post(_ptc.text, _t.id, _groupName);
    } else {
      p = new Post(_ptc.text,'',_groupName);
    }
    try {
      String responseBody = await postRequestWriteAuthorization(
          'http://proj-309-ss-5.cs.iastate.edu:3000/api/create-post',
          json.encode(p));
      print("create_post responseBody: " + responseBody);
      goHome(context);
    } catch (exception) {
      print('send post exception' + exception.toString());
    }
  }

  _selectTab() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new SelectTab(_ptc.text,_groupName)));
  }

// build of CreatePost, provides UI for creating a Post
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Create Post'),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.home),
              onPressed: () {
                goHome(context);
              })
        ],
      ),
      body: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new TextField(
                controller: _ptc,
              ),
              new Padding(padding: new EdgeInsets.all(8.0)),
              new RaisedButton(
                onPressed: _selectTab,
                child: new Text('Select Tab'),
              ),
              new Padding(padding: new EdgeInsets.all(8.0)),
              new RaisedButton(
                onPressed: _finalizePost,
                child: new Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
