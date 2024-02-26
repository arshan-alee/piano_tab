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
    var libraryData = json['data']['UserLibrary'];

    List<String> library;

    if (libraryData is String) {
      if (libraryData == "[]") {
        library = [];
      } else {
        library = [libraryData];
      }
    } else if (libraryData is List) {
      if (libraryData == []) {
        library = [];
      } else {
        library = List<String>.from(libraryData);
      }
    } else {
      // Handle other cases (e.g., empty or null data)
      library = [];
    }

    return UserData(
      points: json['data']['Points'].toString(),
      userDataLibrary: library,
    );
  }
}
