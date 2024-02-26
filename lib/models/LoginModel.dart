// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';
part 'LoginModel.g.dart';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

@HiveType(typeId: 0)
class LoginModel extends HiveObject {
  @HiveField(0)
  final String status;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String authToken;

  @HiveField(4)
  final DateTime expirationDate;

  LoginModel({
    required this.status,
    required this.message,
    required this.email,
    required this.authToken,
    required this.expirationDate,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        message: json["message"],
        email: json["email"],
        authToken: json["auth_token"],
        expirationDate: DateTime.parse(json["expirationDate"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "email": email,
        "auth_token": authToken,
        "expiration_date":
            "${expirationDate.year.toString().padLeft(4, '0')}-${expirationDate.month.toString().padLeft(2, '0')}-${expirationDate.day.toString().padLeft(2, '0')}",
      };
}
