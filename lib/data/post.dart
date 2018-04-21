import 'package:ss_5/util/globals.dart' as globals;
import 'tab.dart';
///Posts are objects that store the data for Posts (user and group posts)
class Post {
  String _content;
  String _tabID;
  String _groupName;
  String _authorUsername;
  Tabb _tab;

  Post(String content, [tabID = '', groupName = '', Tabb tab]) {
    _content = content;
    _authorUsername = globals.user.username;
    _tabID = tabID;
    _groupName = groupName;
    _tab = tab;
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

  get tab => _tab;

  get tabID => _tabID;

  get content => _content;

  get authorUsername => _authorUsername;
}
