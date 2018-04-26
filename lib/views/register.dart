import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import 'package:ss_5/data/registerdata.dart';
import 'package:ss_5/communications/servercommunication.dart';
import 'package:ss_5/data/logindata.dart';
import 'package:ss_5/communications/fileIO.dart';
import 'package:ss_5/util/globals.dart' as globals;
///Register is a StatelessWidget that allows a user to register for an account
///for StringCenter. A user must enter firstName, lastName, username, password,
///and confirmpassword.
class Register extends StatelessWidget {
  bool registerSuccess = false;
  static final TextEditingController _firstname = new TextEditingController();
  static final TextEditingController _lastname = new TextEditingController();
  static final TextEditingController _username = new TextEditingController();
  static final TextEditingController _password = new TextEditingController();
  static final TextEditingController _confirmpassword =
      new TextEditingController();

  String get firstName => _firstname.text;

  String get lastName => _lastname.text;

  String get username => _username.text;

  String get password => _password.text;

  String get confirmpassword => _confirmpassword.text;

  _sendRegister() async {
    var url =
        "http://proj-309-ss-5.cs.iastate.edu:3000/api/register"; // URL for registration
    registerdata rd = new registerdata(
        firstName, lastName, username, password, confirmpassword);
    var js = json.encode(rd.toJson());
    print("register data encoded to json: " + js.toString());
    try {
      String responseBody = await postRequestWrite(url, js);
      registerSuccess = true;
    } catch (exception) {
      registerSuccess = false;
      print("exception: (register) " + exception.toString());
    }
  }
  _sendLogin() async {
    var url = "http://proj-309-ss-5.cs.iastate.edu:3000/api/sign-in";
    logindata ld = new logindata(username, password);
    String js = json.encode(ld.toJson());
    print("json (login in register): " + js);
    try {
      //send postRequest and get responseBody
      String responseBody = await postRequestWrite(url, js);

      //Save token into token.txt
      Map m = json.decode(responseBody);
      String token = m['token'];
      String dir = (await getApplicationDocumentsDirectory()).path;
      writeFileFromString(token, "token.txt", dir);
    } catch (exception) {
      print("exception: (login in register) " + exception.toString());

    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: globals.themeColor,
        title: new Text('Register'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new TextField(
                controller: _firstname,
                decoration:
                    new InputDecoration(hintText: 'Enter your first name'),
              ),
              new TextField(
                controller: _lastname,
                decoration:
                    new InputDecoration(hintText: 'Enter your last name'),
              ),
              new TextField(
                controller: _username,
                decoration:
                    new InputDecoration(hintText: 'Enter your username'),
              ),
              new TextField(
                controller: _password,
                decoration:
                    new InputDecoration(hintText: 'Enter your password'),
                obscureText: true,
              ),
              new TextField(
                controller: _confirmpassword,
                decoration:
                    new InputDecoration(hintText: 'Enter your password again'),
                obscureText: true,
              ),
              new Padding(padding: new EdgeInsets.all(32.0)),
              new RaisedButton(
                child: new Text('Register'),
                onPressed: () async {
                  await _sendRegister();
                  if (registerSuccess){
                    await _sendLogin();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        'Home', (Route<dynamic> route) => false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
