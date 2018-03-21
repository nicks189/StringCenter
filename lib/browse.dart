import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'post.dart';
import 'servercommunication.dart';
import 'dart:convert';
import 'tab.dart';
import 'group_object.dart';
import 'user.dart';

class Browse extends StatefulWidget {

  @override
  _BrowseState createState() =>
      new _BrowseState();

}

class _BrowseState extends State<Browse> {

  List<Widget> _widgetList = new List<Widget>();
  List<Tabb> _tabList = new List<Tabb>();
  List<User> _userList = new List<User>();
  List<Group> _groupList = new List<Group>();

  _getPostList() async { // TODO wrong
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

  _getTabList() async {
    var url = "";
    try {

      for (int i = 0; i < ;i++) {

      }
    } catch(exception) {
      print("browse gettablist exception: " + exception.toString());
    }
  }
  _getGroupList() async {
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-groups";
    try {
      String responseBody = await getRequest(url);


    } catch(exception) {
      print("browse getgrouplist exception: " + exception.toString());
    }
  }
  _getUserList() async {
    var url = "";
    try {

    } catch(exception) {
      print("browse getuserlist exception: " + exception.toString());
    }
  }

  List<Widget> _generateWidgets() { //TODO need 3 genwidgets

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
        child: new Text(_postList[i].title),
      )
      );
    }
    return widgetList;
  } //_generateWidgets

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Browse")
      ),
      body: new Container(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new RaisedButton(
                    child: new Text("Tabs"),
                    onPressed: () {
                    },
                  ),
                  new RaisedButton(
                    child: new Text("Groups"),
                    onPressed: () {

                    },
                  ),
                  new RaisedButton(
                    child: new Text("Users"),
                    onPressed: () {

                    },
                  ),
                ],
              ),
              new ListView(scrollDirection: Axis.vertical ,children: _widgetList),
            ],
          ),
        ),
      ),
    );
  }
}