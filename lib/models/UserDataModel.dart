import 'dart:convert';

import 'package:hive/hive.dart';
part 'UserDataModel.g.dart';

UserData UserModelFromJson(String str) => UserData.fromJson(json.decode(str));

String UserModelToJson(UserData data) => json.encode(data.toJson());

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
    var libraryData = json['data']['library'];

    List<String> library;

    if (libraryData is String) {
      // If libraryData is a single string, create a list with that string
      library = [libraryData];
    } else if (libraryData is List) {
      // If libraryData is a list, assume it's a list of strings
      library = List<String>.from(libraryData);
    } else {
      // Handle other cases (e.g., empty or null data)
      library = [];
    }

    return UserData(
      points: json['data']['points'],
      userDataLibrary: library,
    );
  }
}
