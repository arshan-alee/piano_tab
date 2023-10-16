import 'dart:convert';

import 'package:hive/hive.dart';

part 'OfflineLibrary.g.dart';

@HiveType(typeId: 2)
class OfflineLibrary {
  @HiveField(0)
  bool isLoggedIn;

  @HiveField(1)
  String points;

  @HiveField(2)
  List<String> offlineLibrary;

  OfflineLibrary({
    bool? isLoggedIn,
    String? points,
    List<String>? offlineLibrary,
  })  : isLoggedIn = isLoggedIn ?? false,
        points = points ?? '0', // Set default value as '0'
        offlineLibrary =
            offlineLibrary ?? []; // Set default value as an empty list

  Map<String, dynamic> toJson() {
    return {
      'isLoggedIn': isLoggedIn,
      'points': points,
      'offlineLibrary': offlineLibrary,
    };
  }

  static String encodeOfflineLibrary(List<String> offlineLibrary) {
    return json.encode(offlineLibrary);
  }
}
