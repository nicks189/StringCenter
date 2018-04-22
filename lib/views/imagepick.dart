import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ss_5/data/user.dart';
import 'dart:convert';
import 'package:ss_5/util/globals.dart' as globals;
import 'dart:async';
import 'package:ss_5/communications/servercommunication.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      Upload(_image);
    });
    try {
      var url =
          "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-user/info";
      String responseBody = await getRequestAuthorization(url);
      Map users = json.decode(responseBody);
      globals.user.profilePic(users['profilePic']);
    } catch (exception) {
      print("viewUserList exception: " + exception.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Image Picker Example'),
      ),
      body: new Center(
        child: _image == null
            ? new Text('No image selected.')
            : new Image.file(_image),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}