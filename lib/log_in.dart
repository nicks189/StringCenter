import 'package:flutter/material.dart';

import "dart:convert";
import "dart:io";
import 'logindata.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'globals.dart' as globals;
import 'servercommunication.dart';
class Login extends StatelessWidget {

  static final TextEditingController _username = new TextEditingController();
  static final TextEditingController _password = new TextEditingController();

  String get username => _username.text;
  String get password => _password.text;


  bool auth = false;
  String sg = "";

  //auth refers to whether login attempt succeeded
  //message is used to make authorization wait in the context
  _sendLogin() async {

    var url ="http://proj-309-ss-5.cs.iastate.edu:3000/api/sign-in";
    var httpClient = new HttpClient();
    String result;
    logindata ld = new logindata(username, password);
    String json = JSON.encode(ld.toJson());
    print ("json (login): " + json);
    try {
      //send postRequest and get responseBody
      String responseBody = await postRequestWrite(url, json);

      //Save token into token.txt
      Map m = JSON.decode(responseBody);
      String token = m['token'];
      String dir = (await getApplicationDocumentsDirectory()).path;
      writeFileFromString(token, "token.txt", dir);

      globals.token = token;
      globals.username = username;


      auth = true;
      sg = "done";

      result = 'success';
    } catch (exception) {
      sg = "fail";
      result = 'fail';
      print("exception: (login) " + exception.toString());
      auth = false;
    }
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
              new Padding(padding: new EdgeInsets.all(32.0)),
              new RaisedButton(
                child: new Text('Login'),
                onPressed:() async {

                  await _sendLogin();
                  print("auth :" + auth.toString());
                  //while(sg == "");
                  _username.clear();
                  _password.clear();
                   if(auth) Navigator.of(context).pushNamedAndRemoveUntil('Home', (Route<dynamic> route) => false);
                  },
              ),
              new Text("Don't have an account?"),
              new RaisedButton(
                child: new Text("Register"),
                onPressed:(){Navigator.of(context).pushNamed('Register');},
              ),
            ],
          ),
        ),
      ),
    );
  }
}