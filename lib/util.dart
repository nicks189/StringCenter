import 'home.dart';
import 'package:flutter/material.dart';

///util contains helpful methods that are needed by many Widgets
goHome(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      new MaterialPageRoute(builder: (BuildContext context) => new Home()),
      (Route<dynamic> route) => false);
}
