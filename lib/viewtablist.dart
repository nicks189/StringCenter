import 'package:flutter/material.dart';
import "dart:convert";
import "dart:io";
import 'tab.dart';
import 'viewtab.dart';

class viewTabList extends StatefulWidget {

  _viewTabListState createState() => new _viewTabListState();
}

  class _viewTabListState extends State<viewTabList> {

    bool _loaded = false;
    List<Tabb> _tabs = new List<Tabb>();
    List<Widget> _wl = new List<Widget>();

  _getTabList() async {//'http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/findTabsByAuthorName/:author_username' //
    var url = 'http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/findTabsByUser';
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
      request.headers.add("authorization", "bearer eyJhbGciOiJIUzI1NiJ9.NWE4ODlkYWUyZjkzOGMyZDAxZjVkMjdl.3s6PeRjyZUPSgHi3whRkS2-iGQJyvyZ-snauby7XvWE");

      var response = await request.close();
      var json = await response.transform(UTF8.decoder).join();
      Map jsonD = JSON.decode(json);
      print(json);
      print(jsonD['tabs'].length);
      for (int i = 0; i < jsonD['tabs'].length;i++) {
        _tabs.add(new Tabb.fromJson(jsonD['tabs'][i]));
      }
      //_tabs.add(JSON.decode(json));
      _generateWidgets();


    } catch(exception) {
      print('exception viewtablist');
    }



  }

  List<Widget> _generateWidgets() {

    print(_tabs.length);
    for (int i = 0; i < _tabs.length ;i ++){
      //TODO put code for populating widget list
      _wl.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new viewTab(_tabs[i])));
      },
        child: new Text("Hello"),
      ));

    }
  return _wl;
  }

  @override
  Widget build(BuildContext context) {
    if(_loaded == false) {
      _loaded = true;
      _getTabList();
    }
    print("tabs: " + _tabs.toString());
    print("widgets: " + _wl.toString());
    return new Scaffold(
      appBar: new AppBar(title: new Text('View Tab List'),),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(children: _wl),
        ),
      ),
    );
  }

}