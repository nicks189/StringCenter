import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:string_center_client/data/tab.dart';
import 'selectTab.dart';
import 'package:string_center_client/data/post.dart';
import 'package:string_center_client/communications/servercommunication.dart';
import 'package:string_center_client/views/home.dart';
import 'package:string_center_client/util/util.dart';
import 'package:string_center_client/util/globals.dart' as globals;
/// CreatePost is a StatefulWidget that allows a user to create a Post which may
/// or may not contain a Tabb object, and may or may not contain a text field
class CreatePost extends StatefulWidget {
  Tabb _t;
  String _s;
  String _groupName;

  CreatePost([String s, String groupName, Tabb t]) {
    _t = t;
    _s = s;
    _groupName = groupName;
  }

  @override
  _CreatePostState createState() => new _CreatePostState(_s, _groupName, _t);
}

// State for CreatePost
class _CreatePostState extends State<CreatePost> {
  Tabb _t;
  String _s;
  String _groupName;
  String _tabHintText;
  TextEditingController _ptc = new TextEditingController();

  _CreatePostState([String s = '', String groupName = '', Tabb t]) {
    _t = t;
    _s = s;
    _ptc.text = s;
    _groupName = groupName;

    if(_t == null) {
      _tabHintText = "No tab selected";
    }
    else _tabHintText = _t.title;
  }

  _finalizePost() async {
    Post p;
    if (_t != null) {
      p = new Post(globals.user.username, _ptc.text, _t.id, _groupName,_t);
    } else {
      p = new Post(globals.user.username, _ptc.text,'',_groupName);
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
        backgroundColor: globals.themeColor,
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
        child: new MaterialButton(
          onPressed: (){FocusScope.of(context).requestFocus(new FocusNode());},
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: new Center(
          child: new Column(
            children: <Widget>[
              new TextField(
                maxLines: 10,
                decoration: new InputDecoration(
                  hintText: "Enter the content of your post...",
                    border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.all(new Radius.circular(1.0)),
                        borderSide: new BorderSide(color: globals.themeColor))),
                controller: _ptc,
              ),
              new Padding(padding: new EdgeInsets.all(8.0)),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: _selectTab,
                    child: new Text('Select Tab'),
                  ),
                  new Container(
                    margin: new EdgeInsets.all(10.0),
                    padding: new EdgeInsets.all(12.0),
                    child: new Text(_tabHintText),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.all(new Radius.circular(1.0)),
                      border: new Border.all(
                        color: new Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ],
              ),
              new Padding(padding: new EdgeInsets.all(8.0)),
              new RaisedButton(
                onPressed: _finalizePost,
                child: new Text('Post'),
              ),
              new Padding(padding: new EdgeInsets.all(12.0),),
            ],
          ),
        ),
       ),
      ),
    );
  }
}
