import 'globals.dart' as globals;

class Post {

  String _content;
  String _tabID;
  String _groupName;
  String _authorUsername;

  Post(String content, [tabID='', groupName='']) {
    _content = content;
    _authorUsername = globals.user.username;
    _tabID = tabID;
    _groupName = groupName;
  }

  Map toJson() {
    Map map = new Map();
    map['content'] = _content;
    map['tabId'] = _tabID;
    map['groupName'] = _groupName;
    return map;
  }


  get content => _content;

}