import 'globals.dart' as globals;
///Posts are objects that store the data for Posts (user and group posts)
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
    if(_tabID != '') {
      map['tabId'] = _tabID;
    }
    map['groupName'] = _groupName;
    return map;
  }

  get tabID => _tabID;
  get content => _content;
  get authorUsername => _authorUsername;

}