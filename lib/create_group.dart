import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'post.dart';
import 'servercommunication.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'group_object.dart';
import 'create_post.dart';
import 'view_post.dart';
import 'util.dart';

///GroupCreationPage is a StatefulWidget that displays a group's page based on the
///groupname supplied as the parameter _givenGroupName to the Widget
class CreateGroup extends StatefulWidget {

  @override
  _CreateGroupState createState() => new _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _desc = new TextEditingController();



  _save() {
    Map m = new Map();
    m['groupName'] = _name.text;
    m['description'] = _desc.text;
    m['username'] = globals.user.username;
    postRequestWriteAuthorization('http://proj-309-ss-5.cs.iastate.edu:3000/api/create-group', json.encode(m));
    goHome(context);
  }

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: globals.themeColor,
        title: new Text("GroupName"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Scaffold(
                          //TODO goto settings screen
                          body: new Text("settings screen stub"),
                        )));
              }),
          new IconButton(
              icon: new Icon(Icons.home),
              onPressed: () {
                goHome(context);
              }),
        ],
      ),
      body: new Container(
        padding: new EdgeInsets.all(40.0),
        child: new Column(
          children: <Widget>[
            new TextField(
              controller: _name,
              decoration: new InputDecoration(
                hintText: 'Enter Group Name',
             ),
            ),
            new Padding(padding: new EdgeInsets.all(15.0)),
            new TextField(
              controller: _desc,
              decoration: new InputDecoration(
                hintText: 'Enter Group Description',
              ),
            ),
            new Padding(padding: new EdgeInsets.all(15.0)),
            new RaisedButton(onPressed: _save, child: new Text('Create Group'),)
          ],
        ),
      ),
    );
  }
}
