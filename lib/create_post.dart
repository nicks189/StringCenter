import 'package:flutter/material.dart';

import 'dart:convert';

import 'tab.dart';
import 'selectTab.dart';
import 'post.dart';
import 'servercommunication.dart';
import 'home.dart';

class CreatePost extends StatefulWidget {
  Tabb _t;
  String _s;

  CreatePost([Tabb t, String s]) {
    _t = t;
    _s = s;
  }

  @override
  _CreatePostState createState() => new _CreatePostState(_t, _s);
}


class _CreatePostState extends State<CreatePost> {

  Tabb _t;
  String _s;
  TextEditingController _ptc = new TextEditingController();

  _CreatePostState([Tabb t, String s='']) {
    _t = t;
    _s = s;
   _ptc.text = s;
  }
  
  _finalizePost() {
    Post p;
    if(_t != null) {
      p = new Post(_ptc.text, _t.id);
    }else{
      p = new Post(_ptc.text);
    }
    try {
      postRequestWriteAuthorization(
          'http://proj-309-ss-5.cs.iastate.edu:3000/api/create-post',
          json.encode(p));
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) => new Home()));
    } catch (exception) {
      print('send post exception' + exception.toString());
    }
  }

  _selectTab() {
    Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new SelectTab(_ptc.text)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Create Post'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new TextField(
                controller: _ptc,
              ),
              new RaisedButton(onPressed: _selectTab, child: new Text('Select Tab'),),
              new RaisedButton(onPressed: _finalizePost, child: new Text('Post'),),
            ],
          ),
        ),
      ),
    );
  }
}