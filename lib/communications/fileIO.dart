import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

//returns Future<String> of file
//if file doesn't exist, returns String "DNE"
Future<String> readFileAsString(String filename, String dir) async {
  Future<bool> b = new File('$dir/$filename').exists();
  print('path/filename (servercom): $dir/$filename');
  String token = "";
  if (await b) {
    File f = new File('$dir/$filename');
    token = await f.readAsString();
    print("token (servercom):  " + token);
  } else
    return "DNE";
  return token;
}

//writes [input] to [dir] with [filename] as the filename
//used by log in
writeFileFromString(String input, String filename, String dir) async {
  File f = new File('$dir/$filename');
  await f.writeAsString(input);
}

//deletes file [filename] from directory [dir]
//used by home
deleteFile(String filename, String dir) {
  try {
    File f = new File('$dir/$filename');
    f.delete();
  } catch (exception) {
    print('Delete file exception: ' + exception.toString());
  }
}