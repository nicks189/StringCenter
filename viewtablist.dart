import 'package:flutter/material.dart';
import "dart:convert";
import "dart:io";
import 'tab.dart';
import 'viewtab.dart';

class viewTabList extends StatelessWidget {

  List<Tabb> _tabs = new List<Tabb>();
  List<Widget> _wl = new List<Widget>();

  /*viewTabList(List<Tabb> tabs, List<Widget> wl) {
    _tabs = tabs;
    _wl = wl;
  }*/
  _gotoTab(String title) {

  }
 // _viewTabListState createState() => new _viewTabListState();


  /*class _viewTabListState extends State<viewTabList>*/

  _getTabList() async {//'http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/findTabsByAuthorName/:author_username' //
    var url = 'http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/findTabsByUser';
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
      var response = await request.close();
      var json = await response.transform(UTF8.decoder).join();
      print(json);
      //_tabs.add();


    } catch(exception) {
      print('exception viewtablist');
    }
  }

  @override
  Widget build(BuildContext context) {
    _getTabList();
    for (int i = 0; i < _tabs.length ;i ++){
    //TODO put code for populating widget list
    _wl.add(new MaterialButton(onPressed: () {
      Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new viewTab(_tabs[i])));
    },));

    }

    return new Scaffold(
      appBar: new AppBar(title: new Text('View Tab List'),),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new ListView(children: _wl),
        ),
      ),
    );
  }

}