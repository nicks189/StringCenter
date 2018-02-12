import 'package:flutter/material.dart';

class TabOptions extends StatefulWidget {
  _TabOptionsState createState() => new _TabOptionsState();
}

class _TabOptionsState extends State<TabOptions> {

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _infoController = new TextEditingController();
  TextEditingController _instrumentController = new TextEditingController();
  TextEditingController _tuningController = new TextEditingController();
  String ddd = "";

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
                 hint: new Text('Select an Instrument'),
                 items: [new DropdownMenuItem(value: 'Guitar', child: new Text('Guitar'),), new DropdownMenuItem(value: 'Bass', child: new Text('Bass'),)],
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
            new RaisedButton(child: new Text('Next'), onPressed: null),
          ],
        ),
      ),
    );
  }
}