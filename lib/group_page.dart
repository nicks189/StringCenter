import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'post.dart';
import 'servercommunication.dart';
import 'dart:convert';
import 'group_object.dart';
class GroupPage extends StatefulWidget {
  String _givenGroupName;

  GroupPage(givenGroupName) {
    _givenGroupName = givenGroupName;
  }

  @override
  _GroupPageState createState() =>
      new _GroupPageState(_givenGroupName);

}

class _GroupPageState extends State<GroupPage> {
  String _groupName;
  List<Widget> _widgetList = new List<Widget>();
  List<Post> _postList = new List<Post>();
  Group _group;
_GroupPageState(_givenGroupName)  {
  _groupName = _givenGroupName;
  _group = new Group(_groupName);
}

  _getPostList() async {
    var url ="http://proj-309-ss-5.cs.iastate.edu:3000/api/get-group-posts";
    try {
      Map m = {"groupName" : "$_groupName"};
      String js = json.encode(m);
      String responseBody = await postRequestWrite(url, js);
      List posts = json.decode(responseBody);
      print("posts.length: "+ posts.length.toString());
      for(int i = 0; i < posts.length; i++) {
        _postList.add(new Post(posts[i]["title"], posts[i]["content"]));
      }
    } catch(exception) {
      print("grouppage exception: " + exception.toString());
    }
  }

  @override
  void initState() {
    _getPostList().then((widgetList) {
      widgetList = _generateWidgets();
      setState(() {
        _widgetList = widgetList;
      });
    });
  }




  List<Widget> _generateWidgets() {

  List<Widget> widgetList = new List<Widget>();
    widgetList.add( new Container(
      margin: new EdgeInsets.all(24.0),
      padding: new EdgeInsets.all(12.0),
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.blue, width: 2.0),
        borderRadius: new BorderRadius.all(new Radius.circular(6.0)),

      ),
      child: new Text("new group description test test description new new test "
          "new description new new test description new test new test")
    ),
    );

    widgetList.add(new Container(
      child: new MaterialButton(
        minWidth: 128.0,
        height: 32.0,
        child: new Text("Create Post", style: new TextStyle(color: Colors.white, fontSize: 16.0),),
    onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new Scaffold(
            body: new Text("Post Creation Screen"),
          )));
        }
      ),
      margin: new EdgeInsets.all(24.0),
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.red),
            borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
        color: Colors.red,
      ),
    ));
    for (int i = 0; i < _postList.length; i++) {
      widgetList.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new Scaffold(
            body: new Text(_postList[i].content),
        )));
      },
          child: new Text(_postList[i].content),
      )
      );
    }
  return widgetList;
  } //_generateWidgets

  @override
  Widget build(BuildContext context) {
    if(_widgetList == null) {
      return new Container(child: new Column(children: [new Text("Loading..."),]));
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
          child: new ListView(scrollDirection: Axis.vertical ,children: _widgetList),
          ),
        ),
      );
  }
}