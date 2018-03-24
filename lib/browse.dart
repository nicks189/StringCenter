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

  @override
  void initState() {
    _widgetList.add(new SizedBox(height: 8.0,));
  }

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
        _tabList.removeRange(0, _tabList.length);

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
        _groupList.removeRange(0, _groupList.length);
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
      _userList.removeRange(0, _userList.length);
      for (int i = 0; i < users["users"].length; i++) {
        _userList.add(new User(users["users"][i]["username"],
                                users["users"][i]["description"]));
      }

    } catch(exception) {
      print("browse getuserlist exception: " + exception.toString());
    }
  }

  List<Widget> _genTabWidgets() {
    List<Widget> widgetList = new List<Widget>();
    for(int i = 0; i < _tabList.length; i++) {
      widgetList.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new ViewTab(_tabList[i])));
      },
      child: new Text(_tabList[i].title),
      ));
   }
    return widgetList;
  }
  List<Widget> _genGroupWidgets() {
    List<Widget> widgetList = new List<Widget>();
    for(int i = 0; i < _groupList.length; i++) {
      widgetList.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new GroupPage(_groupList[i].groupName)));
      },
        child: new Text(_groupList[i].groupName),
      ));
    }
    return widgetList;
  }
  List<Widget> _genUserWidgets() {
    List<Widget> widgetList = new List<Widget>();
    for(int i = 0; i < _userList.length; i++) {
      widgetList.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new ViewUser(_userList[i].username)));
      },
        child: new Text(_userList[i].username),
      ));
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Browse")
      ),
      body: new Container(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new RaisedButton(
                    padding: new EdgeInsets.all(8.0),
                    child: new Text("Tabs"),
                    onPressed: () {
                      _getTabList().then((wl) {
                        wl = _genTabWidgets();
                        setState(() {
                          _widgetList = wl;
                        });
                      });
                    },
                  ),
                  new RaisedButton(
                    padding: new EdgeInsets.all(8.0),
                    child: new Text("Groups"),
                    onPressed: () {
                      _getGroupList().then((wl) {
                        wl = _genGroupWidgets();
                        setState((){
                          _widgetList = wl;
                        });
                      });
                    },
                  ),
                  new RaisedButton(
                    padding: new EdgeInsets.all(8.0),
                    child: new Text("Users"),
                    onPressed: () {
                      _getUserList().then((wl) {
                        wl = _genUserWidgets();
                        setState(() {
                          _widgetList = wl;
                        });
                      });
                    },
                  ),
                ],
              ),
              new Expanded(child: new ListView(scrollDirection: Axis.vertical ,children: _widgetList),),

            ],
          )
        ),
      ),
    );
  }
}