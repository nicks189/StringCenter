import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'globals.dart' as globals;

/**
 * returns Future<String> of file
 * if file doesn't exist, returns String "DNE"
 */
Future<String> readFileAsString(String filename) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  Future<bool> b = new File('$dir/$filename').exists();
  print('path/filename (servercom): $dir/$filename');
  String token = "";
  if (await b) {
    File f = new File('$dir/$filename');
    token = await f.readAsString();
    print("token (servercom):  " + token);
  }
  else return "DNE";
  return token;
}

