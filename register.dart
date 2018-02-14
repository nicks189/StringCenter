import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'registerdata.dart';

class Register extends StatelessWidget {

  static final TextEditingController _firstname = new TextEditingController();
  static final TextEditingController _lastname = new TextEditingController();
  static final TextEditingController _username = new TextEditingController();
  static final TextEditingController _password = new TextEditingController();
  static final TextEditingController _confirmpassword = new TextEditingController();

  String get firstName => _firstname.text;
  String get lastName => _lastname.text;
  String get username => _username.text;
  String get password => _password.text;
  String get confirmpassword => _confirmpassword.text;


  _sendRegister(bool auth) async {
    var url ="http://proj-309-ss-5.cs.iastate.edu:3000/api/register"; // URL for registration
    var httpClient = new HttpClient();
    String result;
    registerdata rd = new registerdata(firstName, lastName, username, password, confirmpassword);
    var json = JSON.encode(rd.toJson());
    print (json);
    try {
      var request = await httpClient.postUrl(Uri.parse(url)); // initial request to URL
      print(Uri.parse(url));
      request.headers.contentType = new ContentType("application", "json", charset: "utf-8"); //specifiying contentType to be json (application)
      request.write(json); // actually sending regiserdata to url
      var response = await request.close(); // completing request
      var responseBody = await response.transform(UTF8.decoder).join(); // parsing response from server
      print('BODY: $responseBody'); // printing respond from server
      print(JSON.decode(responseBody));
      var data = JSON.decode(responseBody);
      //TODO (if success result = success)
      result = 'success';

    } catch (exception) {
      result = 'fail';
      print(exception);
    }
    auth = rd.auth(result);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Register'),),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new TextField(controller: _firstname, decoration: new InputDecoration(hintText: 'Enter your first name'),),
              new TextField(controller: _lastname, decoration: new InputDecoration(hintText: 'Enter your last name'),),
              new TextField(controller: _username, decoration: new InputDecoration(hintText: 'Enter your username'),),
              new TextField(controller: _password, decoration: new InputDecoration(hintText: 'Enter your password'), obscureText: true,),
              new TextField(controller: _confirmpassword, decoration: new InputDecoration(hintText: 'Enter your password again'), obscureText: true,),
              new Padding(padding: new EdgeInsets.all(32.0)),
              new RaisedButton(
                child: new Text('Register'),
                onPressed:(){
                  bool a = false;
                  _sendRegister(a); // TODO
                  if(a) Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}