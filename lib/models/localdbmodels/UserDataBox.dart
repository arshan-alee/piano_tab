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

  static Future<void> setDefault() async {
    if (_userBox != null) {
      final defaultModel = UserData(
        points: '0', // Set your default points value here
        userDataLibrary: [], // Set your default library value here
      );
      await _userBox!.clear();
      await _userBox!.put("userdata", defaultModel);
    }
  }

  static Future<void> updateLibrary(List<String> library) async {
    if (_userBox != null) {
      final userData = _userBox!.get("userdata");
      if (userData != null) {
        userData.userDataLibrary.addAll(library);
        await _userBox!.put("userdata", userData);
      }
    }
  }

  static Future<void> updatePoints(String points) async {
    if (_userBox != null) {
      final userData = _userBox!.get("userdata");
      if (userData != null) {
        userData.points = points;
        await _userBox!.put("userdata", userData);
      }
    }
  }
}
