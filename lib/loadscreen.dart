import 'package:flutter/material.dart';
import 'viewtablist.dart';
import 'tab.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

requestUser(bool isLoggedIn) async {


  String url = 'http://proj-309-ss-5.cs.iastate.edu:3000/api/get-user/info/';


  var httpClient = new HttpClient();
  String result;

  var json;

  try {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File f = new File('$dir/token.txt');

    var request = await httpClient.getUrl(Uri.parse(url));
    print(Uri.parse(url));
    String token = await f.readAsString();

    request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
    request.headers.add("authorization", "bearer 4$token");

    var response = await request.close();
    var responseBody = await response.transform(UTF8.decoder).join();

    print('BODY: $responseBody'); // fields are in quotes except the last is "__v":0
    //TODO (if success result = success)

    //Save token into token.txt

    if (responseBody == "Unauthorized") {

    }
    else {
      isLoggedIn = true;
    }
    result = 'success';
  } catch (exception) {
    result = 'fail';
    print(exception);
  }

}
class LoadScreen extends StatelessWidget {
  String _message;
  bool _loaded;


  navigate(bool isLoggedIn, BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false;
    if(_loaded == false) {
      _loaded = true;
      requestUser(isLoggedIn);
    }
    if(!isLoggedIn) Navigator.of(context).pushNamedAndRemoveUntil('Login', (Route<dynamic> route) => false);
    navigate(isLoggedIn, context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
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
            ],
          ),
        ),
      ),
    );

  }
}
