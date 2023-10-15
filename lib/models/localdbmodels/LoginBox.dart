import 'package:hive/hive.dart';
import 'package:paino_tab/models/LoginModel.dart';

class LoginBox {
  static Box<LoginModel>? _userBox;

  // Initialize the Hive box, this should be called once, preferably in your app initialization.
  static Future<void> init() async {
    _userBox = await Hive.openBox<LoginModel>("hiveuser");
  }

  static Box<LoginModel>? get userBox {
    if (_userBox == null) {
      throw Exception("User box has not been initialized.");
    }
    return _userBox;
  }
}
