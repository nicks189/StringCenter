import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
 * used by Browse (get group list)
 */
Future<String> getRequest(String url) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
  var response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}

 //used by home and profile
Future<String> getRequestTokenAuthorization(String url, String token) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
  request.headers.add("authorization", "bearer $token");
  var response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}

/**
 * used by viewtablist and followers (gets token from local storage of token)
 */
Future<String> getRequestAuthorization(String url) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
  request.headers.add("authorization", "bearer ${globals.token}");
  var response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}
/**
 * used by log_in, register, and group_page
 */
Future<String> postRequestWrite(String url, String json) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.postUrl(Uri.parse(url));
  request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
  request.write(json);
  var response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}
/**
 * view user
 */
Future<String> postRequestWriteAuthorization(String url, String json) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.postUrl(Uri.parse(url));
  request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
  request.headers.add("authorization", "bearer ${globals.token}");
  request.write(json);
  var response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}

/**
 * used by log_in
 */
writeFileFromString(String input, String filename, String dir) async {
  File f = new File('$dir/$filename');
  await f.writeAsString(input);
}
/**
 * used by home
 *
 */
deleteFile(String filename, String dir) {
  File f = new File('$dir/$filename');
  f.delete();
}