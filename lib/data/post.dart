import 'package:ss_5/util/globals.dart' as globals;
import 'tab.dart';
///Posts are objects that store the data for Posts (user and group posts)
class Post {
  String _content;
  String _tabID;
  String _groupName;
  String _authorUsername;
  Tabb _tab;
  bool _hasTab;

  Post(String username, String content, [tabID = '', groupName = '', Tabb tab]) {
    _content = content;
    _authorUsername = username;
    _tabID = tabID;
    _groupName = groupName;
    _tab = tab;
    if (tabID == '') _hasTab = false;
      else _hasTab = true;

  }

  Map toJson() {
    Map map = new Map();
    map['content'] = _content;
    if (_tabID != '') {
      map['tabId'] = _tabID;
      map['tab'] = _tab.toJson();
    }
    map['groupName'] = _groupName;
    return map;
  }

  String tabRender() {
    String t = '';
    if (_tabID == '') return t;
    else
      {
        t = t + 'Name: ' + _tab.title + '\n';
        t = t + 'Author: ' + _authorUsername + '\n';
        String temp = "";
        // for (Measure measure in _measures) {

          Measure measure = _tab.measures[0];
          t = t + '\n';
          for (int i = measure.stringCount - 1; i >= 0; i--) {
            temp += measure.strings[i].tuning + ' ';
            for (String note in measure.strings[i].notes) {
              temp += note + ' ';
            }
            t = t + temp + '\n';
            temp = "";
          }
        }
        return t;
      }

  get tab => _tab;

  get tabID => _tabID;

  get content => _content;

  get authorUsername => _authorUsername;

  get hasTab => _hasTab;
}
