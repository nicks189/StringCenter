import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';

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


  _sendRegister() async { //TODO
    var url ="http://proj-309-ss-5.cs.iastate.edu:3000/api/register";
    var httpClient = new HttpClient();
    String result;
    user rd = new user("john", "smith", "jsmitty420", "hunter2", "hunter2");
    var json = JSON.encode(rd.toJson());
    print (json);
    try {
      var request = await httpClient.postUrl(Uri.parse(url));
      print(Uri.parse(url));
      request.write(json);
      var response = await request.close();
      var responseBody = await response.transform(UTF8.decoder).join();
      print('BODY: $responseBody');
      print(JSON.decode(responseBody));
      var data = JSON.decode(responseBody);
      result = data['message'];
    } catch (exception) {
      result = 'no';
      print(exception);
    }
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
              new RaisedButton(
                child: new Text('Register'),
                onPressed:(){
                  //  _sendRegister(); // TODO
                  // if(auth) then vvv
                  Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
                },
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}