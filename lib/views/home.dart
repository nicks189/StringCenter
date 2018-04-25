import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:ss_5/data/post.dart';
import 'package:ss_5/views/log_in.dart';
import 'package:ss_5/communications/servercommunication.dart';
import 'package:ss_5/views/viewtablist.dart';
import 'package:ss_5/views/followers.dart';
import 'package:ss_5/views/profile.dart';
import 'view_post.dart';
import 'package:ss_5/data/tab.dart';
import 'my_groups.dart';
import 'package:ss_5/views/create_group.dart';
import 'package:ss_5/util/globals.dart' as globals;
import 'package:ss_5/data/user.dart';
import 'package:ss_5/views/browse.dart';
import 'package:ss_5/views/following.dart';
import 'package:ss_5/util/util.dart';
import 'package:ss_5/communications//fileIO.dart';
import 'package:ss_5/views/search.dart';
import 'package:ss_5/util/util.dart';
///Home is a StatefulWidget that is the home screen of the app. This screen isn't accessible if
///a user is not logged in. This Widget checks if a user is logged in every time it is opened.
class Home extends StatefulWidget {
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  String _message;
  List<Widget> _widgetList = new List<Widget>();
  List<Post> _postList = new List<Post>();
  bool _loaded = false;
  TextStyle buttonStyle = new TextStyle(color: Colors.white, fontFamily: 'times',fontSize: 24.0);
  TextStyle tstyle = new TextStyle(color: Colors.black,fontFamily: 'monospace');
  Widget _page = new Container();
  double _textBoxWidth(bool hasTab) {
    if (hasTab) return 128.0;
    else return 312.0;
  }

  _HomeState() {
    _message = '';

  }

  _HomeState.withMessage(String message) {
    _message = message;
  }

  @override
  void initState() {
     _requestUser().then((_loaded){
       _getPostList().then((widgetList) {
         widgetList = _generateWidgets();
         setState(() {
           _widgetList = widgetList;
         });
       });
       setState(() {
         _loaded = true;
       });
     });
  }

  void _refresh(){
    _postList = new List<Post>();
      _getPostList().then((widgetList) {
        widgetList = _generateWidgets();
        setState(() {
          _widgetList = widgetList;
        });
      setState(() {
        _loaded = true;
      });
    });
  }

  _getPostList() async {
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/newsfeed";
    try {
      String responseBody =
      await getRequestAuthorization(url);
      print(responseBody);
      Map posts = json.decode(responseBody);

      if (posts['posts'] != null) {
        print("posts.length: " + posts['posts'].length.toString());

        for (int i = 0; i < posts['posts'].length; i++) {
          if (posts['posts'][i]['tab'] != null) {
            _postList.add(new Post(posts['posts'][i]['authorUsername'],
                posts['posts'][i]["content"],
                posts['posts'][i]['tabId'],
                posts['posts'][i]['groupName'],
                Tabb.fromJson(posts['posts'][i]['tab']),
                new User(posts['posts'][i]['user']['username'], posts['posts'][i]['user']['profilePic'])));
          } else {
            _postList.add(new Post(posts['posts'][i]['authorUsername'], posts['posts'][i]["content"], '',
                posts['posts'][i]['groupName'], null, new User(posts['posts'][i]['user']['username'], posts['posts'][i]['user']['profilePic'])));
          }
        }
      }
    } catch (exception) {
      print("newsfeed exception: " + exception.toString());
    }
  }

  List<Widget> _generateWidgets() {
    List<Widget> widgetList = new List<Widget>();
    for (int i = 0; i < _postList.length; i++) {
      widgetList.add(new Container(
        margin: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
        decoration:
        new BoxDecoration(color: new Color.fromARGB(230, 255, 255, 255),border: Border.all(color: globals.themeColor)),
        constraints: new BoxConstraints(maxWidth: 128.0, maxHeight: 168.0),
        child: new MaterialButton(
          padding: new EdgeInsets.all(0.0),
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new ViewPost(_postList[i])));
          },
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    constraints: new BoxConstraints(maxWidth: 120.0, maxHeight: 32.0),
                    padding: new EdgeInsets.all(6.0),
                    margin: new EdgeInsets.fromLTRB(0.0, 0.0, 18.0, 4.0),
                    child: new Row(
                      children: <Widget>[
                        new Image.network("http://proj-309-ss-5.cs.iastate.edu:3000/${_postList[i].user.profilePic}", fit: BoxFit.scaleDown,),
                        new Padding(padding: new EdgeInsets.only(right: 10.0)),
                        new Text(_postList[i].authorUsername, style: tstyle,),
                      ],
                    ),

                    decoration: new BoxDecoration(border: new Border(
                      right: new BorderSide(color: globals.themeColor),
                      bottom: new BorderSide(color: globals.themeColor),
                    ),
                    ),
                  ),
                  new Container(
                    constraints: new BoxConstraints(maxWidth: _textBoxWidth(_postList[i].hasTab), maxHeight: 196.0),
                    margin: new EdgeInsets.fromLTRB(12.0, 2.0, 18.0, 6.0),
                    padding: new EdgeInsets.all(4.0),
                    child: new Text(_postList[i].content, maxLines: 6, style: tstyle,),
                    decoration: new BoxDecoration(
                      border: new Border.all(color: globals.themeColor),
                    ),
                  ),
                ],
              ),
              new Text(_postList[i].tabRender(), style: tstyle,),
            ],
          ),
        ),
      ),
      );
    }
    return widgetList;
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
        User u = new User(m['username'], m['profilePic'], m['_id'], m['description'], m['adminStatus']);
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
            title: new Text('Newsfeed'),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.refresh),
                  onPressed:  _refresh),
              new IconButton(
                  icon: new Icon(Icons.exit_to_app),
                  onPressed: () async {
                    await resetAuth();
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
                  title: new Text("My Tabs", style: buttonStyle),
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
                  title: new Text("My Groups", style: buttonStyle),
                  onTap:(){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (
                              BuildContext context) => new MyGroups(),
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
                  title: new Text("Create Group", style: buttonStyle),
                  onTap:(){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (
                                BuildContext context) => new CreateGroup()));
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
                fit: BoxFit.cover,
                  image: new AssetImage("images/guitar.jpg")),
            ),
          alignment: Alignment.center,
          padding: new EdgeInsets.all(20.0),
          child: new ListView(
            children: _widgetList,
          ),
        ),
        );
    }
  }// end build
} // end class _HomeState
