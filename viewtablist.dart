import 'package:flutter/material.dart';
import "dart:convert";
import "dart:io";
import 'tab.dart';

class viewTabList extends StatelessWidget {

  List<Tabb> tabs = new List<Tabb>();
  List<Widget> wl = new List<Widget>();

  _gotoTab(String title) {

  }

  _getTabList() async {//'http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/findTabsByAuthorName/:author_username' //
    var url = 'http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/findTabsByAuthorName/:author_username';
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
      var response = await request.close();
      var json = await response.transform(UTF8.decoder).join();
      wl.add(new MaterialButton(onPressed:() {
        Navigator.push(context, new MaterialPageRoute(
            builder:(BuildContext context) => new CreateMeasure(createTab()) // delete
        ));
      }));
    } catch(exception) {
      print('exception viewtab');
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO put code for populating widget list
    return new Scaffold(
      appBar: new AppBar(title: new Text('View Tab List'),),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new ListView(children: wl),
        ),
      ),
    );
  }

}