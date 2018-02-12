class logindata {
  String firstName;
  String lastName;
  String username;
  String password;
  String confirmPassword;
  String id;

  logindata(this.username, this.password);

  Map toJson() {
    return {
      "username" : username,
      "password" : password};

  }
  bool auth(String _in) {
    if (_in == 'success')
      return true;
    else return false;
  }
}
