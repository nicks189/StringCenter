///registerdata is an object used for storing and parsing information given on the register screen
class registerdata {
  String firstName;
  String lastName;
  String username;
  String password;
  String confirmPassword;
  String id;

  registerdata(this.firstName, this.lastName, this.username, this.password,
      this.confirmPassword);

  Map toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "password": password,
      "confirmPassword": confirmPassword
    };
  }

  bool auth(String _in) {
    if (_in == 'success')
      return true;
    else
      return false;
  }
}
