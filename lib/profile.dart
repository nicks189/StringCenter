import 'package:flutter/material.dart';

import 'package:flutter/services.dart';


import 'globals.dart' as globals;

class Profile extends StatefulWidget {
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool loaded = false;
  Image i = new Image.asset('einstein.jpg');
  ByteData bd;

  _makeByteArray() async {
    bd = await rootBundle.load('images/einstein.jpg');
    setState((){
    });
  }

  _createWList() {

  }

  @override
  Widget build(BuildContext context) {
    if(loaded == false) {
      _makeByteArray();
      loaded = true;
    }
    try{
      print(bd.toString());
    } catch(exception, stackTrace) {
      print(exception);
    }
    return new Scaffold(
      appBar: new AppBar(
        leading: new Image.asset('images/einstein.jpg', fit: BoxFit.scaleDown,),
        title: new Text(globals.username),
      ),
      body: new Container(
        alignment: Alignment.center,
        padding: new EdgeInsets.all(20.0),
          child: new ListView(
            children: <Widget>[
              new Row(

                children: <Widget>[
                  i,
                  new Image.asset('images/einstein.jpg', fit: BoxFit.scaleDown,),
                ],
              ),
              new Row(
                children: <Widget>[
                  i,
                  new Image.asset('images/einstein.jpg', fit: BoxFit.scaleDown,),
                ],
              ),
              new Row(
                children: <Widget>[
                  i,
                  new Text('hasflkasjdflkajs;fa'),
                ],
              ),
              new Row(
                children: <Widget>[
                  i,
                  new Text('ajdf;lasdfjklasjlk;df'),
                ],
              ),
              new Row(
                children: <Widget>[
                  i,
                  new Text('ajdf;lasdfjklasjlk;df'),
                ],
              ),
              new Row(
                children: <Widget>[
                  i,
                  new Text('ajdf;lasdfjklasjlk;df'),
                ],
              ),
              new Row(
                children: <Widget>[
                  i,
                  new Text('ajdf;lasdfjklasjlk;df'),
                ],
              ),
              new Row(
                children: <Widget>[
                  i,
                  new Text('ajdf;lasdfjklasjlk;df'),
                ],
              ),
              new Row(
                children: <Widget>[
                  i,
                  new Text('ajdf;lasdfjklasjlk;df'),
                ],
              ),
              new Row(
                children: <Widget>[
                  i,
                  new Text('ajdf;lasdfjklasjlk;df'),
                ],
              ),
              new Row(
                children: <Widget>[
                  i,
                  new Text('ajdf;lasdfjklasjlk;df'),
                ],
              ),
              new Row(
                children: <Widget>[
                  i,
                  new Text('ajdf;lasdfjklasjlk;df'),
                ],
              ),
            ],
          ),
        ),
    );
  }
}