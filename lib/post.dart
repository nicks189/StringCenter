import 'globals.dart' as globals;

class Post {

  String _content;
  String _tabID;
  String _groupName;
  String _authorUsername;

  Post(String content, [tabID='', groupName='']) {
    _content = content;
    _authorUsername = globals.user.username;
  }

  get content => _content;
  get authorUsername => _authorUsername;

}