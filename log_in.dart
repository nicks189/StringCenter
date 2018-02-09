import 'package:flutter/material.dart';

class Login extends StatelessWidget {

  static final TextEditingController _username = new TextEditingController();
  static final TextEditingController _password = new TextEditingController();

  String get username => _username.text;
  String get password => _password.text;

  _sendLogin() async { //TODO
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
                //  _sendLogin(); // TODO
                  // if(auth) then vvv
                  Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
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