import 'package:flutter/material.dart';
import 'package:ss_5/data/tab.dart';
class EditTab extends StatefulWidget {
  Tabb _t;
  EditTab(Tabb t){
    _t = t;
  }
  _EditTabState createState() =>
      new _EditTabState(_t);
}

class _EditTabState extends State<EditTab> {
  Tabb _t;
  _EditTabState(Tabb t) {
    _t = t;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold();
  }
}