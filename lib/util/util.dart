import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ss_5/views/home.dart';
import 'package:ss_5/communications/fileIO.dart';
import 'package:ss_5/util/globals.dart' as globals;

///util contains helpful methods that are needed by many Widgets
goHome(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      new MaterialPageRoute(builder: (BuildContext context) => new Home()),
      (Route<dynamic> route) => false);
}

resetAuth() async {
  globals.isLoggedIn = false;
  globals.token = "";
  globals.user = null;
  String dir = (await getApplicationDocumentsDirectory()).path;
  deleteFile('token.txt', dir);
}
