import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:string_center_client/views/home.dart';
import 'package:string_center_client/communications/fileIO.dart';
import 'package:string_center_client/util/globals.dart' as globals;
import 'dart:io';

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
  File f = new File ("$dir/token.txt");
  if(await f.exists()) {
    deleteFile('token.txt', dir);
  }
}
