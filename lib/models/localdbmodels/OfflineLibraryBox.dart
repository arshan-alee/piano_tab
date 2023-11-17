import 'package:hive/hive.dart';
import 'package:paino_tab/models/OfflineLibrary.dart';
import 'package:paino_tab/utils/model.dart';

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

  static Future<bool> addToFavorites(String favouriteItem) async {
    final box = await Hive.openBox<OfflineLibrary>(boxName);
    final offlinelibrary = box.get(boxName);

    if (offlinelibrary != null) {
      if (favouriteItem.isNotEmpty &&
          !offlinelibrary.favourites.contains(favouriteItem)) {
        offlinelibrary.favourites.add(favouriteItem);
        await box.put(boxName, offlinelibrary);
        return true;
      }
    }

    return false;
  }

  static Future<bool> removeFromFavorites(String favouriteItem) async {
    final box = await Hive.openBox<OfflineLibrary>(boxName);
    final offlinelibrary = box.get(boxName);

    if (offlinelibrary != null) {
      if (favouriteItem.isNotEmpty &&
          offlinelibrary.favourites.contains(favouriteItem)) {
        offlinelibrary.favourites.remove(favouriteItem);
        await box.put(boxName, offlinelibrary);
        return true;
      }
    }

    return false;
  }

  static Future<void> updateRating(double rating) async {
    box = await Hive.openBox<OfflineLibrary>(boxName);
    final offlineLibrary = box!.get(boxName);

    if (offlineLibrary == null) {
      final newOfflineLibrary = OfflineLibrary(rating: rating);
      await box!.put(boxName, newOfflineLibrary);
    } else {
      offlineLibrary.rating = rating;
      await box!.put(boxName, offlineLibrary);
    }
  }

  static Future<bool> addToCart(ListItemModel cartItem) async {
    final box = await Hive.openBox<OfflineLibrary>(boxName);
    var offlineLibrary = box.get(boxName);

    offlineLibrary ??= OfflineLibrary(cartItems: []);

    // Check if the cartItem is already present
    if (!offlineLibrary.cartItems.contains(cartItem)) {
      offlineLibrary.cartItems.add(cartItem);
      await box.put(boxName, offlineLibrary);
      return true;
    } else {
      // cartItem is already present, return false
      return false;
    }
  }

  static Future<bool> removeFromCart(ListItemModel cartItem) async {
    final box = await Hive.openBox<OfflineLibrary>(boxName);
    final offlineLibrary = box.get(boxName);

    if (offlineLibrary != null) {
      offlineLibrary.cartItems.remove(cartItem);
      await box.put(boxName, offlineLibrary);
      return true;
    }

    return false;
  }

  static Future<void> emptyCart() async {
    final box = await Hive.openBox<OfflineLibrary>(boxName);
    final offlineLibrary = box.get(boxName);

    if (offlineLibrary != null) {
      offlineLibrary.cartItems.clear();
      await box.put(boxName, offlineLibrary);
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
          isLoggedIn: false,
          points: '0',
          offlineLibrary: [],
          favourites: [],
          rating: 0.0,
          cartItems: []);
      await box!.clear();
      await box!.put(boxName, defaultModel);
    }
  }
}
