import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:paino_tab/utils/model.dart';

part 'OfflineLibrary.g.dart';

@HiveType(typeId: 2)
class OfflineLibrary {
  @HiveField(0)
  bool isLoggedIn;

  @HiveField(1)
  String points;

  @HiveField(2)
  List<String> offlineLibrary;

  @HiveField(3)
  List<String> favourites;

  @HiveField(4)
  double rating;

  @HiveField(5)
  List<ListItemModel> cartItems;

  OfflineLibrary(
      {bool? isLoggedIn,
      String? points,
      List<String>? offlineLibrary,
      List<String>? favourites,
      double? rating,
      List<ListItemModel>? cartItems})
      : isLoggedIn = isLoggedIn ?? false,
        points = points ?? '0',
        offlineLibrary = offlineLibrary ?? [],
        favourites = favourites ?? [],
        rating = rating ?? 0.0,
        cartItems = cartItems ?? [];

  Map<String, dynamic> toJson() {
    return {
      'isLoggedIn': isLoggedIn,
      'points': points,
      'offlineLibrary': offlineLibrary,
      'favourites': favourites,
      'rating': rating,
      'cartItems': cartItems
    };
  }

  static String encodeOfflineLibrary(List<String> offlineLibrary) {
    return json.encode(offlineLibrary);
  }
}
