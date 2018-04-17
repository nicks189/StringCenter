import 'globals.dart' as globals;

///User's are objects that model the data for users.
class User {
  String _username;
  String _userID;
  String _description;
  bool _isAdmin;
  User(String username, [String userID = '', String description = '', bool isAdmin = false]) {
    _username = username;
    _userID = userID;
    _description = description;
    _isAdmin = isAdmin;
  }

  void set description(String s) {
    _description = s;
  }

  get username => _username;

  get userID => _userID;

  get description => _description;

  get isAdmin => _isAdmin;
}
