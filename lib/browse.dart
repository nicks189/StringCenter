import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'post.dart';
import 'servercommunication.dart';
import 'dart:convert';
import 'tab.dart';
import 'group_object.dart';
import 'user.dart';
import 'viewtab.dart';
import 'group_page.dart';
import 'viewUser.dart';

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

  _genTabWidgets() {
  List<Widget> widgetList = new List<Widget>();
    for(int i = 0; i < _tabList.length; i++) {
      widgetList.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new ViewTab(_tabList[i])));
      },
      child: new Text(_tabList[i].title),
      ));
   }
    setState(() {
     _widgetList = widgetList;
    });
  }
   _genGroupWidgets() {
    List<Widget> widgetList = new List<Widget>();
    for(int i = 0; i < _groupList.length; i++) {
      widgetList.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new GroupPage(_groupList[i].groupName)));
      },
        child: new Text(_groupList[i].groupName),
      ));
    }
    setState(() {
      _widgetList = widgetList;
    });
  }
  _genUserWidgets() { //TODO make viewUser and edit accordingly
    List<Widget> widgetList = new List<Widget>();
    for(int i = 0; i < _groupList.length; i++) {
      widgetList.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new GroupPage(_groupList[i].groupName)));
      },
        child: new Text(_groupList[i].groupName),
      ));
    }
    setState(() {
      _widgetList = widgetList;
    });
  }

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
                      _getTabList().then(() {
                        _genTabWidgets();
                      });
                    },
                  ),
                  new RaisedButton(
                    child: new Text("Groups"),
                    onPressed: () {
                      _getGroupList().then(() {
                        _genTabWidgets();
                      });
                    },
                  ),
                  new RaisedButton(
                    child: new Text("Users"),
                    onPressed: () {
                      _getUserList().then(() {
                        _genTabWidgets();
                      });
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