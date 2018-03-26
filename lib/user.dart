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

  get username => _username;
  get userID => _userID;
  get description => _description;
}