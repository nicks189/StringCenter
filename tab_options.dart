import 'package:flutter/material.dart';

import 'tab.dart';
import 'create_measure.dart';

class TabOptions extends StatefulWidget {
  _TabOptionsState createState() => new _TabOptionsState();
}

class _TabOptionsState extends State<TabOptions> {

  Map<num, String> m = {1 : 'Guitar', 2 : 'Bass'};
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _infoController = new TextEditingController();
  TextEditingController _tuningController = new TextEditingController();

  void _selected(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('New Tab Info'),
      ),
      body: new Container(
        padding: const EdgeInsets.all(32.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
           new TextField(
             controller : _titleController,
             decoration : new InputDecoration(
               hintText: 'Enter Tab Title',
             ),
           ),
           new TextField(
             controller : _infoController,
             decoration : new InputDecoration(
               hintText: 'Enter Tab Info',

             ),
           ),
           new Row(
             children: <Widget>[
               new DropdownButton<String>(
                 value : m[2],
                 hint: new Text('Select an Instrument'),
                 items: [new DropdownMenuItem(value: m[1], child: new Text(m[1]),), new DropdownMenuItem(value: m[2], child: new Text(m[2]),)],
                 onChanged: (_) {},
               ),
             ],
           ),
           new TextField(
             controller : _tuningController,
             decoration : new InputDecoration(
               hintText: 'Enter Tuning',
             ),
           ),
            new RaisedButton(
              child: new Text('Next'),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(
                  builder:(BuildContext context) => new CreateMeasure(_titleController.text, _infoController.text, _tuningController.text)
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}