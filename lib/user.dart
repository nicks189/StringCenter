import 'globals.dart' as globals;

class User {

  String _username;
  String _userID;
  String _description;


  User(String username, String userID, [String description='']) {
    _username = username;
    _userID = userID;
    _description = description;
  }

  void set description(String s) {
    _description = s;
  }

  get username => _username;
  get userID => _userID;
  get description => _description;

}