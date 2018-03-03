import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'globals.dart' as globals;

/**
 * returns Future<String> of file
 * if file doesn't exist, returns String "DNE"
 */
Future<String> readFileAsString(String filename, String dir) async {
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
/**
 * used by home
 */
Future<String> getRequestToken(String url, String token) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
  request.headers.add("authorization", "bearer $token");
  var response = await request.close();
  String responseBody = await response.transform(UTF8.decoder).join();
  return responseBody;
}
/**
 * used by viewtablist
 */
Future<String> getRequest(String url) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
  request.headers.add("authorization", "bearer ${globals.token}");
  var response = await request.close();
  String responseBody = await response.transform(UTF8.decoder).join();
  return responseBody;
}
/**
 * used by log_in and register
 */
Future<String> postRequestWrite(String url, String json) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.postUrl(Uri.parse(url));
  request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
  request.write(json);
  var response = await request.close();
  String responseBody = await response.transform(UTF8.decoder).join();
  return responseBody;
}
/**
 * used by log_in
 */
writeFileFromString(String input, String filename, String dir) async {
  File f = new File('$dir/$filename');
  await f.writeAsString(input);
}