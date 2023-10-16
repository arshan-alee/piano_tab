import 'package:hive/hive.dart';
import 'package:paino_tab/models/OfflineLibrary.dart';

class OfflineLibraryBox {
  static Box<OfflineLibrary>? box;
  static const String boxName = 'offlineLibraryBox';
  static Future<void> init() async {
    box = await Hive.openBox<OfflineLibrary>(boxName);
  }

  static Future<void> updateIsLoggedIn(bool isLoggedIn) async {
    box = await Hive.openBox<OfflineLibrary>(boxName);
    final offlineLibrary = box!.get(boxName);

    if (offlineLibrary == null) {
      final newOfflineLibrary = OfflineLibrary(isLoggedIn: isLoggedIn);
      await box!.put(boxName, newOfflineLibrary);
    } else {
      offlineLibrary.isLoggedIn = isLoggedIn;
      await box!.put(boxName, offlineLibrary);
    }
  }

  static Future<void> updatePoints(String points) async {
    box = await Hive.openBox<OfflineLibrary>(boxName);
    final offlineLibrary = box!.get(boxName);

    if (offlineLibrary == null) {
      final newOfflineLibrary = OfflineLibrary(points: points);
      await box!.put(boxName, newOfflineLibrary);
    } else {
      offlineLibrary.points = points;
      await box!.put(boxName, offlineLibrary);
    }
  }

  static Future<bool> updateLibrary(String libraryItem) async {
    final box = await Hive.openBox<OfflineLibrary>(boxName);
    final offlineLibrary = box.get(boxName);

    if (offlineLibrary != null) {
      if (libraryItem.isNotEmpty &&
          !offlineLibrary.offlineLibrary.contains(libraryItem)) {
        offlineLibrary.offlineLibrary.add(libraryItem);
        await box.put(boxName, offlineLibrary);
      }
      return true;
    } else {
      return false;
    }
  }

  static Box<OfflineLibrary>? get userBox {
    if (box == null) {
      throw Exception("Offline Library box has not been initialized.");
    }
    return box;
  }

  static Future<void> setDefault() async {
    if (box != null) {
      final defaultModel = OfflineLibrary(
        isLoggedIn: false, // Set your default isLoggedIn value here
        points: '0', // Set your default points value here
        offlineLibrary: [], // Set your default library value here
      );
      await box!.clear();
      await box!.put(boxName, defaultModel);
    }
  }
}
