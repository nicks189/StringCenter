import 'package:flutter/material.dart';

import 'tab.dart';

void main() {
  Tabb t = new Tabb('hello');
  t.printTabb();
  t.addMeasure('First Measure', 4, 10);
}

class _StringCenterState extends State<StringCenter> {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Container(
          alignment: Alignment.bottomCenter,
          child: new RaisedButton(onPressed: null),
        ),
      ),
    );
  }

}

class StringCenter extends StatefulWidget {
  _StringCenterState createState() => new _StringCenterState();
}