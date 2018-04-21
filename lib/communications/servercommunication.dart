import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:ss_5/util/globals.dart' as globals;

///servercommunication contains methods for sending requests to the server and for
///reading and writing files locally.

// sends a get request to [url]
// contains header 'application/json'
// returns response from server as Future<String>
// used by Browse (get group list)
Future<String> getRequest(String url) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  request.headers.contentType =
      new ContentType("application", "json", charset: "utf-8");
  var response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}

//sends get request to [url]
//contains header 'application/json'
//contains header 'authorization/bearer $[token]'
//returns response from server as Future<String>
//used by home and profile
Future<String> getRequestTokenAuthorization(String url, String token) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  request.headers.contentType =
      new ContentType("application", "json", charset: "utf-8");
  request.headers.add("authorization", "bearer $token");
  var response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}

//sends get request to [url]
//contains header 'application/json'
//contains header 'authorization/bearer token' where token is token of current user
//returns response from server as Future<String>
//used by viewtablist, followers, and search (gets token from local storage of token)
Future<String> getRequestAuthorization(String url) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  request.headers.contentType =
      new ContentType("application", "json", charset: "utf-8");
  request.headers.add("authorization", "bearer ${globals.token}");
  var response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}

//Post request to [url]
//body is written with [json]
//returns response from server as Future<String>
//used by log_in, register, group_page, and createMeasure
Future<String> postRequestWrite(String url, String json) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.postUrl(Uri.parse(url));
  request.headers.contentType =
      new ContentType("application", "json", charset: "utf-8");
  request.write(json);
  var response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}

//Post request to [url]
//body is written with [json]
//contains header 'application/json', and a header 'authorization/bearer $token' where token is current user's token
//returns response from server as Future<String>
// used by view user
Future<String> postRequestWriteAuthorization(String url, String json) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.postUrl(Uri.parse(url));
  request.headers.contentType =
      new ContentType("application", "json", charset: "utf-8");
  request.headers.add("authorization", "bearer ${globals.token}");
  request.write(json);
  var response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}

//Put request to [url] with body [json]
//contains header application/json
//contains header authorization/bearer token
//returns response from server as Future<String>
Future<String> putRequestWriteAuthorization(String url, String json) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.putUrl(Uri.parse(url));
  request.headers.contentType =
      new ContentType("application", "json", charset: "utf-8");
  request.headers.add("authorization", "bearer ${globals.token}");
  request.write(json);
  var response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}

//Delete request to [url] with body [json]
//contains header application/json
//contains header authorization/bearer token
//returns response from server as Future<String>
Future<String> deleteRequestWriteAuthorization(String url, String json) async {
  HttpClient httpClient = new HttpClient();
  var request = await httpClient.deleteUrl(Uri.parse(url));
  request.headers.contentType =
      new ContentType("application", "json", charset: "utf-8");
  request.headers.add("authorization", "bearer ${globals.token}");
  request.write(json);
  var response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}
