import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'package:ss_5/views/log_in.dart';
import 'package:ss_5/communications/servercommunication.dart';
import 'package:ss_5/views/viewtablist.dart';
import 'package:ss_5/views/followers.dart';
import 'package:ss_5/views/profile.dart';
import 'package:ss_5/views/create_group.dart';
import 'package:ss_5/util/globals.dart' as globals;
import 'package:ss_5/data/user.dart';
import 'package:ss_5/views/browse.dart';
import 'package:ss_5/views/following.dart';
import 'package:ss_5/util/util.dart';
import 'package:ss_5/communications//fileIO.dart';
import 'package:ss_5/views/search.dart';

///Home is a StatefulWidget that is the home screen of the app. This screen isn't accessible if
///a user is not logged in. This Widget checks if a user is logged in every time it is opened.
class Home extends StatefulWidget {
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  String _message;
  bool _loaded = false;
  TextStyle buttonStyle = new TextStyle(color: Colors.white, fontFamily: 'times',fontSize: 24.0);
  Widget _page = new Container();

  _HomeState() {
    _message = '';
  }

  _HomeState.withMessage(String message) {
    _message = message;
  }

  @override
  void initState() {
     _requestUser().then((_loaded){
       setState(() {
         _loaded = true;
       });
     });

  }

  _requestUser() async {
    String url = 'http://proj-309-ss-5.cs.iastate.edu:3000/api/get-user/info/';

    try {
      //store token from file into String (if doesn't exist, returns "DNE")
      String dir = (await getApplicationDocumentsDirectory()).path;
      String token = await readFileAsString('token.txt', dir);
      //get request to server, returns "Unauthorized" if token isn't legit
      String responseBody = await getRequestTokenAuthorization(url, token);
      print("home" + responseBody);
      if (responseBody == "Unauthorized") {
        resetAuth();
        setState(() {
          _loaded = true;
        });
      } else {
        globals.isLoggedIn = true;
        Map m = json.decode(responseBody);
        User u = new User(m['username'], m['_id'], m['description'], m['adminStatus']);
        globals.user = u;
        globals.token = token;
        setState((){
          _loaded = true;
        });

      }
      print("globals.isLoggedin (Home): " + globals.isLoggedIn.toString());
    } catch (exception) {
      resetAuth();
      print("requestuser (home) exception: " + exception.toString());
      setState(() {
        _loaded = true;
      });
    }
  } // end requestUser()

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return new Container();
    }
    else {
      print("globals.isLoggedin: " + globals.isLoggedIn.toString());
      if (!globals.isLoggedIn)
        return new Login();
      else
        return new Scaffold(
          appBar: new AppBar(
            backgroundColor: globals.themeColor,
            title: new Text('Home'),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.exit_to_app),
                  onPressed: () async {
                    String dir = (await getApplicationDocumentsDirectory())
                        .path;
                    deleteFile("token.txt", dir);
                    globals.isLoggedIn = false;
                    globals.user = null;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        'Home', (Route<dynamic> route) => false);
                  })
            ],
          ),
          drawer: new Drawer(
            child: new Container(
              color: globals.themeColor,
            child: new ListView(
              children: <Widget>[
                new ListTile(
                  title: new Text("Profile", style: buttonStyle,),
                  onTap:(){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (
                              BuildContext context) => new Profile(),
                        ));
                  },
                ),
                new ListTile(
                  title: new Text("Your Tabs", style: buttonStyle),
                  onTap:(){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (
                              BuildContext context) => new ViewTabList(),
                        ));
                  },
                ),
                new ListTile(
                  title: new Text("Create Tab", style: buttonStyle),
                  onTap:(){
                    Navigator.of(context).pushNamed('TabOptions');
                  },
                ),
                new ListTile(
                  title: new Text("Search", style: buttonStyle),
                  onTap:(){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (
                              BuildContext context) => new Search(),
                        ));
                  },
                ),
                new ListTile(
                  title: new Text("Browse", style: buttonStyle),
                  onTap:(){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (
                              BuildContext context) => new Browse(),
                        ));
                  },
                ),
              ],
            ),
           ),
          ),
          body: new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("images/guitar.jpg"),
                fit: BoxFit.cover,
              ),

            ),
            padding: new EdgeInsets.all(32.0),
            child: new Center(
              child: new ListView(
                itemExtent: 30.0,
                children: <Widget>[
//              new RaisedButton(
//                child: new Text("Login"),
//                onPressed: () {
//                  Navigator.of(context).pushNamed('Login');
//                },
//             ),
                  new Padding(padding: new EdgeInsets.all(16.0)),
                  new RaisedButton(
                    color: globals.themeColor,
                    child: new Text(
                      "View Tabs",
                      style: buttonStyle,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (
                                BuildContext context) => new ViewTabList(),
                          ));
                    },
                  ),
                  new Padding(padding: new EdgeInsets.all(16.0)),
                  new RaisedButton(
                    color: globals.themeColor,
                    child: new Text("Create Tab", style: buttonStyle,),
                    onPressed: () {
                      Navigator.of(context).pushNamed('TabOptions');
                    },
                  ),
                  new Padding(padding: new EdgeInsets.all(16.0)),
                  new RaisedButton(
                    color: globals.themeColor,
                    child: new Text("Profile", style: buttonStyle,),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (
                                  BuildContext context) => new Profile()));
                    },
                  ),
                  new Padding(padding: new EdgeInsets.all(16.0)),
                  new RaisedButton(
                    color: globals.themeColor,
                    child: new Text("Browse", style: buttonStyle,),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) => new Browse()));
                    },
                  ),
                  new Padding(padding: new EdgeInsets.all(16.0)),
                  new RaisedButton(
                    color: globals.themeColor,
                    child: new Text("Search", style: buttonStyle,),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) => new Search()));
                    },
                  ),
                  new Padding(padding: new EdgeInsets.all(16.0)),
                  new RaisedButton(
                    color: globals.themeColor,
                    child: new Text("CreateGroup", style: buttonStyle,),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (
                                  BuildContext context) => new CreateGroup()));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }// end build
} // end class _HomeState
