import 'package:hive/hive.dart';
import 'package:paino_tab/models/UserDataModel.dart';

class UserDataBox {
  static Box<UserData>? _userBox;

  static Future<void> init() async {
    _userBox = await Hive.openBox<UserData>("userdata");
  }

  static Box<UserData>? get userBox {
    if (_userBox == null) {
      throw Exception("User Data box has not been initialized.");
    }
    return _userBox;
  }
}
