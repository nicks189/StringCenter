import 'package:flutter/material.dart';

import 'tab.dart';
import 'selectTab.dart';

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