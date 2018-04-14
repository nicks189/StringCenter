library ss_5.globals;

import 'package:flutter/material.dart';
import 'user.dart';

///Globals stores data that is required on a global scope
/// current User
User user;

/// true if current User is logged in, if user is null, this will be false
bool isLoggedIn = false;

/// contains authentification token for current user, will be empty if User is null
String token;

/// the color object used as the theme color
Color themeColor = new Color.fromARGB(255, 173, 71, 17);
