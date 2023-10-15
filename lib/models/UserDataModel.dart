import 'dart:convert';

import 'package:hive/hive.dart';

String loginModelToJson(UserData data) => json.encode(data.toJson());

@HiveType(typeId: 1)
class UserData extends HiveObject {
  @HiveField(0)
  String points;

  @HiveField(1)
  List<String> userDataLibrary;

  UserData({
    required this.points,
    required this.userDataLibrary,
  });

  // Convert UserData object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'library': userDataLibrary,
    };
  }

  // Create a UserData object from a JSON map
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      points: json['points'],
      userDataLibrary:
          List<String>.from(json['library'] ?? []), // Handle null 'library'
    );
  }
}
