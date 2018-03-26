import 'home.dart';
import 'package:flutter/material.dart';

 goHome(BuildContext context){
  Navigator.of(context).pushAndRemoveUntil(
      new MaterialPageRoute(builder: (BuildContext context) => new Home()), (Route<dynamic> route) => false
  );
}