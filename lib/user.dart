import 'globals.dart' as globals;

class User {

  String _username;
  String _description;

  User(String username, String userID, [String description]) {
    _username = username;
  }

  get username => _username;
  get description => _description;
}