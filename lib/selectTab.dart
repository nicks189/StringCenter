import 'package:flutter/material.dart';
import "dart:convert";
import "dart:io";
import 'tab.dart';
import 'create_post.dart';
import 'viewtab.dart';
import 'globals.dart' as globals;
import 'servercommunication.dart';
import 'util.dart';
///SelectTab is a StatefulWidget that is routed to from CreatePost.
///In this Widget a list of tabs are fetched and the user selects one to
///attach to a Post they are creating.
class SelectTab extends StatefulWidget {
  String _s;

  SelectTab(String s) {
    _s = s;
  }

  @override
  _SelectTabState createState() => new _SelectTabState(_s);
}

class _SelectTabState extends State<SelectTab> {
  String _s;

  _SelectTabState(String s) {
    _s = s;
  }

  bool _loaded = false;
  List<Tabb> _tabs = new List<Tabb>();
  List<Widget> _wl = new List<Widget>();

  @override
  void initState() {
    _getTabList().then((wl) {
      wl = _generateWidgets();
      setState(() {
        _wl = wl;
      });
    });
  }


  _getTabList() async {
    var url = 'http://proj-309-ss-5.cs.iastate.edu:3000/api/tab/findTabsByUser';
    try {
      //send request
      String responseBody = await getRequestAuthorization(url);
      //decode reponse
      Map js = json.decode(responseBody);
      print("decoded json map: " + js.toString());
      print("js['tabs'].length: " + js['tabs'].length.toString());
      //populate list of tabs from json
      for (int i = 0; i < js['tabs'].length;i++) {
        _tabs.add(new Tabb.fromJson(js['tabs'][i]));
      }
    } catch(exception) {
      print('exception viewtablist');
    }
  }

  List<Widget> _generateWidgets() {
    List<Widget> wl = new List<Widget>();
    print("_tabs.length: " + _tabs.length.toString());
    for (int i = 0; i < _tabs.length ;i ++){
      wl.add(new MaterialButton(onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder:(BuildContext context) => new CreatePost(_tabs[i], _s)));
      },
        child: new Text(_tabs[i].title),
      ));

    }
    return wl;
  }

  @override
  Widget build(BuildContext context) {
    if(_wl == null) {
      return new Container();
    }
    print("tabs: " + _tabs.toString());
    print("widgets: " + _wl.toString());
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('View Tab List'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.home), onPressed: () {goHome(context);}),
        ],
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new ListView(children: _wl),
        ),
      ),
    );
  }

}