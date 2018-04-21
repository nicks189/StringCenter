import 'package:ss_5/util/globals.dart' as globals;

/// Object that stores data for groups
class Group {
  String _groupName;
  String _description;

  Group(String groupName, [String description = '']) {
    _groupName = groupName;
    _description = description;
  }

  get groupName => _groupName;

  get description => _description;
}
