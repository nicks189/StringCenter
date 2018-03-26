import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'dart:convert';
import 'servercommunication.dart';
import 'dart:async';
import 'tab.dart';
import 'post.dart';


import 'globals.dart' as globals;

class EditProfile extends StatefulWidget {

  @override
  _EditProfileState createState() => new _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _aboutMe = new TextEditingController();


  _setChanges() {
    Map m = new Map();
    m['description'] = _aboutMe.text;
    putRequestWriteAuthorization('http://proj-309-ss-5.cs.iastate.edu:3000/api/update-user/${globals.user.username}', json.encode(m));
  }

  @override
  Widget build(BuildContext context) {
    _aboutMe.text = globals.user.description;

    return new Scaffold(
      appBar: new AppBar(
        leading: new Image.asset('images/einstein.jpg', fit: BoxFit.scaleDown,),
        title: new Text('Edit Profile'),
      ),
      body: new Container(
        alignment: Alignment.center,
        padding: new EdgeInsets.all(20.0),
        child: new Column(
          children: <Widget>[
            new Text('About me'),
            new TextField(
              controller: _aboutMe,
            ),
            new Padding(padding: new EdgeInsets.all(20.0)),
            new RaisedButton(onPressed: _setChanges, child: new Text('Apply Changes'),)
          ],
        ),
      ),
    );
  }
}