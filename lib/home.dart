import 'package:flutter/material.dart';
import 'viewtablist.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'log_in.dart';
import 'servercommunication.dart';
import 'globals.dart' as globals;
class Home extends StatefulWidget {
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  String _message;
  Widget _page = new Container();

  _HomeState() {
    _message = '';
  }

  _HomeState.withMessage(String message) {
    _message = message;
  }

  @override
  void initState() {
    _requestUser().then((page){
      page = _generateWidgets();
      setState((){
        _page = page;
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
      String responseBody = await getRequestToken(url, token);

      if (responseBody == "Unauthorized") {
      }
      else {
        globals.isLoggedIn = true;
        Map m = JSON.decode(responseBody);
        globals.username = m['username'];
        globals.token = token;
      }
      print("globals.isLoggedin (home): " + globals.isLoggedIn.toString());

    } catch (exception) {
      print("exception: " + exception.toString());
      _page = new Login();
    }

  } // end requestUser()


  Widget _generateWidgets() {
    if(!globals.isLoggedIn) return new Login();
    else
      _page = new Scaffold(
        appBar: new AppBar(
          title: new Text('Home'),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: () async {
              String dir = (await getApplicationDocumentsDirectory()).path;
              deleteFile("token.txt", dir);
              globals.isLoggedIn = false;
              globals.username = "";
              Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
            })
          ],
        ),
        body: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
//              new RaisedButton(
//                child: new Text("Login"),
//                onPressed: () {
//                  Navigator.of(context).pushNamed('Login');
//                },
//             ),
                new Padding(padding: new EdgeInsets.all(16.0)),
                new RaisedButton(
                  child: new Text("View Tabs"),
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(
                      builder:(BuildContext context) => new ViewTabList(),
                    ));
                  },
                ),
                new Padding(padding: new EdgeInsets.all(16.0)),
                new RaisedButton(
                  child: new Text("Create Tab"),
                  onPressed: () {
                    Navigator.of(context).pushNamed('TabOptions');
                  },
                ),
                new Padding(padding: new EdgeInsets.all(16.0)),
                new RaisedButton(
                  child: new Text("Group Page"),
                  onPressed: () {
                    Navigator.of(context).pushNamed('GroupPage');
                    },
                ),
                new Padding(padding: new EdgeInsets.all(16.0)),
                new RaisedButton(
                  child: new Text("Followers"),
                  onPressed: () {
                    Navigator.of(context).pushNamed('Followers');
                  },
                ),
              ],
            ),
          ),
        ),
      );
    return _page;
  }
  
  @override
  Widget build(BuildContext context) {
    if(_page.runtimeType == new Container().runtimeType) {
      return new Container();
    }
    print("globals.isLoggedin: " + globals.isLoggedIn.toString());
    return _page;

  } // end build
} // end class _HomeState
