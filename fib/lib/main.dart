import 'package:flutter/material.dart';
import 'fib.dart';
void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  fib f = new fib();
  String _myState = '';
  final TextEditingController _controller = new TextEditingController();
  void _pressed(String message) {
    setState(() {
      _myState = f.calculate(int.parse(message)).toString();
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fibonacci',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Fibonacci Calculator"),
        ),
        body: new Container(
          padding: const EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text('Enter the Nth Fibonacci number you want caluclated, then press the button\n'),
                new RaisedButton(onPressed: (){_pressed(_controller.text);}),
                new TextField(
                  controller: _controller,
                  decoration: new InputDecoration(
                    hintText: 'Enter nth Fibonacci number'
                  ),
                ),
                new Text(_myState),
              ],
            ),
          ),
        ),
      ),
    );
  }
}