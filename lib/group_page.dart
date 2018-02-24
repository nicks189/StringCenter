import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class groupPage extends StatefulWidget {
  @override
  _groupPageState createState() => new _groupPageState();
}

class _groupPageState extends State<groupPage> {

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("GroupName"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.settings),
              onPressed: () {

          })
        ],
      ),
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              spacer,
              new MaterialButton(
                child: new Text("Post"),
                onPressed: ()
                {

                },
                height: 40.0,
                minWidth: 64.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}