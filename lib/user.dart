import 'globals.dart' as globals;

class User {

  String _username;

  User(String username) {
    _username = username;
  }
  get username => _username;
}