import 'package:flutter/material.dart';

import "dart:convert";
import "dart:io";
import 'logindata.dart';

class Login extends StatelessWidget {

  static final TextEditingController _username = new TextEditingController();
  static final TextEditingController _password = new TextEditingController();

  String get username => _username.text;
  String get password => _password.text;

  _sendLogin(bool auth) async {
    var url ="http://proj-309-ss-5.cs.iastate.edu:3000/api/sign-in";
    var httpClient = new HttpClient();
    String result;
    logindata ld = new logindata(username, password);
    var json = JSON.encode(ld.toJson());
    print (json);
    try {
      var request = await httpClient.postUrl(Uri.parse(url));
      print(Uri.parse(url));
      request.headers.contentType = new ContentType("json", "application", charset: "utf-8");
      request.write(json);
      var response = await request.close();
      var responseBody = await response.transform(UTF8.decoder).join();
      print('BODY: $responseBody');
      print(JSON.decode(responseBody));
      var data = JSON.decode(responseBody);
      //TODO (if success result = success)
      result = 'success';
    } catch (exception) {
      result = 'fail';
      print(exception);
    }
    auth = ld.auth(result);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Login'),),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new TextField(controller: _username, decoration: new InputDecoration(hintText: 'Enter your username'),),
              new TextField(controller: _password, decoration: new InputDecoration(hintText: 'Enter your password'), obscureText: true,),
              new RaisedButton(
                child: new Text('Login'),
                onPressed:(){
                  bool a = false;
                  _sendLogin(a); // TODO
                   if(a) Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
                  },
              ),
              new Text("Don't have an account?"),
              new RaisedButton(
                child: new Text("Register"),
                onPressed:(){Navigator.of(context).pushNamed('register');},
              ),
            ],
          ),
        ),
      ),
    );
  }
}