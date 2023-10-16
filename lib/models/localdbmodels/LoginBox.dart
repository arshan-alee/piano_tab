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
      throw Exception("Login User box has not been initialized.");
    }
    return _userBox;
  }

  static Future<void> setDefault() async {
    if (_userBox != null) {
      final defaultModel = LoginModel(
        status: '', // Set your default value here
        message: '', // Set your default value here
        email: '', // Set your default value here
        authToken: '', // Set your default value here
        expirationDate: DateTime(2000), // Set your default value here
      );
      await _userBox!.clear();
      await _userBox!.put("hiveuser", defaultModel);
    }
  }
}
