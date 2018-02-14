import 'package:flutter/material.dart';

import 'tab.dart';

class CreateMeasure extends StatefulWidget {
  Tabb _t;
  CreateMeasure(Tabb t) {
    _t = t;
  }
  _CreateMeasureState createState() => new _CreateMeasureState(_t);
}

class _CreateMeasureState extends State<CreateMeasure> {
  Tabb _t;
  
  _CreateMeasureState(Tabb t) {
    _t = t;
  }

  
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Create Measure'),
      ),
      body: new Container(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new ButtonBar(
                    children: <Widget>[

                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
