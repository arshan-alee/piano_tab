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

  OfflineLibrary(
      {bool? isLoggedIn,
      String? points,
      List<String>? offlineLibrary,
      List<String>? favourites,
      double? rating})
      : isLoggedIn = isLoggedIn ?? false,
        points = points ?? '0',
        offlineLibrary = offlineLibrary ?? [],
        favourites = favourites ?? [],
        rating = rating ?? 0.0;

  Map<String, dynamic> toJson() {
    return {
      'isLoggedIn': isLoggedIn,
      'points': points,
      'offlineLibrary': offlineLibrary,
      'favourites': favourites,
      'rating': rating,
    };
  }

  static String encodeOfflineLibrary(List<String> offlineLibrary) {
    print("Encoding Offline Library" + json.encode(offlineLibrary));
    return json.encode(offlineLibrary);
  }
}
