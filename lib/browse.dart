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
  
  _getTabList() async {
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/";
    try {
      //send request
      String responseBody = await getRequestAuthorization(url);
      //decode reponse
      Map js = json.decode(responseBody);
      print("decoded json map: (browse) " + js.toString());
      print("js['tabs'].length: (browse) " + js['tabs'].length.toString());
      //populate list of tabs from json
      for (int i = 0; i < js['tabs'].length;i++) {
        _tabList.add(new Tabb.fromJson(js['tabs'][i]));
      }
    } catch(exception) {
      print("browse gettablist exception: " + exception.toString());
    }
  }
  _getGroupList() async {
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-groups";
    try {
      String responseBody = await getRequest(url);
      Map groups = json.decode(responseBody);
      print("groups.length (browse) : " + groups["groupsByName"].length.toString());
      // populate group list with new group objects parsed from server
      for (int i = 0; i < groups["groupsByName"].length; i++) {
        _groupList.add(new Group(groups["groupsByName"][i]));
      }

    } catch(exception) {
      print("browse getgrouplist exception: " + exception.toString());
    }
  }
  _getUserList() async {
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/get-user/all";
    try {
      String responseBody = await getRequestAuthorization(url);
      Map users = json.decode(responseBody);
      for (int i = 0; i < users["users"].length; i++) {
        _userList.add(new User(users["users"][i]["username"],
                                users["users"][i]["description"]));
      }

    } catch(exception) {
      print("browse getuserlist exception: " + exception.toString());
    }
  }

  List<Widget> _genTabWidgets() {

  }
  List<Widget> _genGroupWidgets() {

  }
  List<Widget> _genUserWidgets() {

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