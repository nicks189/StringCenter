import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ss_5/communications/servercommunication.dart';
import 'package:ss_5/data/tab.dart';
import 'package:ss_5/views/profile.dart';
import 'package:ss_5/data/post.dart';
import 'package:ss_5/util/util.dart';
import 'package:ss_5/util/globals.dart' as globals;

/// EditProfile is a StatefulWidget that allows a user to edit the state of their profile
class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => new _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _aboutMe = new TextEditingController();
  File _image;


  _EditProfileState() {
    _aboutMe.text = globals.user.description;
  }

  _setChanges() async {
    Map m = new Map();
    m['description'] = _aboutMe.text;
    String response = await putRequestWriteAuthorization(
        'http://proj-309-ss-5.cs.iastate.edu:3000/api/update-user/${globals.user
            .username}',
        json.encode(m));
    globals.user.description = _aboutMe.text;
    print(response);
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (BuildContext context) => new Profile()),
        (Route<dynamic> route) => false);
  }

  _changePicture() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() async {
      _image = image;
      await Upload(_image);
    });
  }

  _deleteAccount() async {
    Map m = new Map();
    Map r = new Map();
    String response = await deleteRequestWriteAuthorization(
        'http://proj-309-ss-5.cs.iastate.edu:3000/api/delete-user/${globals.user
            .username}',
        json.encode(m));
    r = json.decode(response);
    print(response);
    print(r);
    if (r['message'] != null) {
      goHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: globals.themeColor,
        leading: new Image.network(
          'http://proj-309-ss-5.cs.iastate.edu:3000/${globals.user.profilePic}',
          fit: BoxFit.scaleDown,
        ),
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
            new RaisedButton(
              onPressed: _changePicture,
              child: new Text('Change Profile Picture'),
            ),
            new Padding(padding: new EdgeInsets.all(20.0)),
            new ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(
                  onPressed: _setChanges,
                  child: new Text('Apply Changes'),
                ),
                new RaisedButton(
                  onPressed: _deleteAccount,
                  child: new Text('Delete Account'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
