import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'post.dart';
class groupPage extends StatefulWidget {
  @override
  _groupPageState createState() => new _groupPageState();
}

class _groupPageState extends State<groupPage> {
  bool _loaded = false;
  List<Widget> _widgetList = new List<Widget>();
  List<Post> _postList = new List<Post>();

  _getPostList() async {
    for(int i = 0; i < 5;i++) { //TODO this is a STUB too
      _postList.add(new Post());
    }
  generateWidgets();
  }

  List<Widget> generateWidgets() {
    _widgetList.add( new Container(
      margin: new EdgeInsets.all(24.0),
      padding: new EdgeInsets.all(12.0),
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.lightBlueAccent),
        borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
        color: Colors.lightBlueAccent
        //TODO do this for the rest of the widgets


      ),
      child: new Text("new group description test test description new new test "
          "new description new new test description new test new test")
    ),
    );


    _widgetList.add(new MaterialButton(
        child: new Row(
          children: <Widget>[
            new Text("Create Post")
          ],
        ),
        height: 64.0,
        minWidth: 256.0,
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new Scaffold(
            body: new Text("Post Creation Screen"),
          )));
        })
    );

    for (int i = 1; i < _postList.length; i++) {
      _widgetList.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new Scaffold(
            body: new Text("$i"),
        ))); //TODO viewPost instead of scaffold
      },
          child: new Text("Thing $i"), //TODO /*_postList[i].title*/ STUB
      )
      );
    }
    return _widgetList;
  }

  @override
  Widget build(BuildContext context) {
    if(_loaded == false) {
      _loaded = true;
      _getPostList();
      setState((){});
    }

    var spacer = new SizedBox(height: 32.0);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("GroupName"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.settings),
              onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new Scaffold( //TODO goto settings screen
                body: new Text("settings screen stub"),
              )));
          })
        ],
      ),
      body: new Container(
        child: new Center(
          child: new Column(
            children: _widgetList
          ),
        ),
      ),

    );
  }
}