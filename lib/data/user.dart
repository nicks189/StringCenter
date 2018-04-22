import 'package:ss_5/util/globals.dart' as globals;

///User's are objects that model the data for users.
class User {
  String _username;
  String _userID;
  String _description;
  bool _isAdmin;
  String _profilePic;
  User(String username, String profilePic, [String userID = '', String description = '', bool isAdmin = false]) {
    _profilePic = profilePic;
    _username = username;
    _userID = userID;
    _description = description;
    _isAdmin = isAdmin;
  }

  void set description(String s) {
    _description = s;
  }


  get profilePic => _profilePic;
  get username => _username;
  get userID => _userID;
  get description => _description;
  get isAdmin => _isAdmin;
}
