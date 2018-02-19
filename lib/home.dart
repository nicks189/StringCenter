import 'package:flutter/material.dart';
import 'viewtablist.dart';
import 'tab.dart';

class Home extends StatelessWidget {
  String _message;

  Home() {
    _message = '';
  }

  Home.withMessage(String message) {
    _message = message;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new RaisedButton(
                child: new Text("Login"),
                onPressed: () {
                  Navigator.of(context).pushNamed('login');
                },
              ),
              new Padding(padding: new EdgeInsets.all(16.0)),
              new RaisedButton(
                child: new Text("View Tabs"),
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(
                      builder:(BuildContext context) => new viewTabList(),
                  ));
                },
              ),
              new Padding(padding: new EdgeInsets.all(16.0)),
              new RaisedButton(
                child: new Text("Create Tab"),
                onPressed: () {
                  Navigator.of(context).pushNamed('tabOptions');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
