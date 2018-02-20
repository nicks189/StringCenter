import 'globals.dart' as globals;

class Post {

  String _title;
  String _content;
  String _tabID;
  String _groupName;
  String _authorUsername;

  post(String title, String content, [tabID='', groupName='']) {
    _title = title;
    _content = content;
    _authorUsername = globals.username;
  }

}