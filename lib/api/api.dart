import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paino_tab/models/LoginModel.dart';
import 'package:paino_tab/models/UserDataModel.dart';
import 'package:paino_tab/models/localdbmodels/LoginBox.dart';
import 'package:paino_tab/models/localdbmodels/UserDataBox.dart';

class ApiService {
  static const String baseUrl = 'https://api.pianotab.com';

  static Future<Map<String, dynamic>> signUp(
      String email, String password) async {
    var request = http.Request('POST', Uri.parse("$baseUrl/signup"));
    request.headers['Content-Type'] = 'application/json';
    request.body = json.encode({"email": email, "password": password});
    http.Response response =
        await http.Response.fromStream(await request.send());
    print(response.body);
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  //login_method can be google/apple/facebook
  static Future<bool> login(String email, String password) async {
    try {
      // var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('$baseUrl/login'));
      request.headers['Content-Type'] = 'application/json';
      request.body = json.encode({"email": email, "password": password});
      // request.headers.addAll(headers);

      http.Response response =
          await http.Response.fromStream(await request.send());
      // final url = Uri.parse('$baseUrl?login');
      // final response =
      //     await http.post(url, body: {'email': email, 'password': password},
      //     // headers: {
      //     //   'Content-Type': 'application/json'
      //     // }
      //     );

      print("logindata response: ${response.body}");

      var _ = loginModelFromJson(response.body);
      var userBox = LoginBox.userBox!;
      if (userBox.values.isNotEmpty) {
        await userBox.clear();
      }
      await userBox.add(_);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<Map<String, dynamic>> getCatalog() async {
    final url = Uri.parse('$baseUrl/catalog');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  //also if you want to bulk retreive you can add &points&library&catalog
  static Future<bool> getUserData(String auth) async {
    print("auth is: ${auth}");
    if (auth == null) {
      // Handle the case where 'auth' is null (e.g., return an error or throw an exception).
      print('Error: auth is null.');
      return false;
    }

    try {
      print("$baseUrl/auth");
      var request = http.Request('POST', Uri.parse('$baseUrl/user'));
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({"auth": auth});

      http.Response response =
          await http.Response.fromStream(await request.send());
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print("user data response: ${jsonResponse['data']}");

      var userData = UserModelFromJson(response.body);

      var userBox = UserDataBox.userBox!;
      if (userBox.values.isNotEmpty) {
        await userBox.clear();
      }
      await userBox.add(userData);

      return true;
    } catch (e) {
      print("Error in storing userdata in userdatabox $e");
      return false;
    }
  }

  static Future<bool> updatePoints(String auth, int newPoints) async {
    var request = http.Request('POST', Uri.parse('$baseUrl/update-points'));

    request.headers['Content-Type'] = 'application/json';

    http.Response response =
        await http.Response.fromStream(await request.send());
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] == "success") {
      print(jsonResponse['message']);
      return true;
    } else {
      print(jsonResponse['message']);
      return false;
    }
  }

  static Future<bool> updateLibrary(String auth, String newLibrary) async {
    var request = http.Request('POST', Uri.parse('$baseUrl/update-library'));
    request.body = json.encode({'auth': auth, 'newLibrary': newLibrary});

    http.Response response =
        await http.Response.fromStream(await request.send());
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] == "success") {
      print(jsonResponse['message']);
      return true;
    } else {
      print(jsonResponse['message']);
      return false;
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    var request = http.Request('POST', Uri.parse('$baseUrl/forgot-password'));

    request.headers['Content-Type'] = 'application/json';

    request.body = json.encode({'email': email});
    // var headers = {'Content-Type': 'application/json'};
    http.Response response =
        await http.Response.fromStream(await request.send());

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('Status: ${data["status"]}, Message: ${data["message"]}');
      return data;
    } else {
      print('Error: ${response.statusCode}');
      return data;
    }
  }

  static Future<Map<String, dynamic>> changePassword(
      String auth, String oldPassword, String newPassword) async {
    var request = http.Request('POST', Uri.parse('$baseUrl/change-password'));

    request.headers['Content-Type'] = 'application/json';

    request.body = json.encode({
      'auth_token': auth,
      'old_password ': oldPassword,
      'new_password': newPassword
    });
    // var headers = {'Content-Type': 'application/json'};
    http.Response response =
        await http.Response.fromStream(await request.send());

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('Status: ${data["status"]}, Message: ${data["message"]}');
      return data;
    } else {
      print('Error: ${response.statusCode}');
      return data;
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
      String resetCode, String newPassword) async {
    var request = http.Request('POST', Uri.parse('$baseUrl/reset-password'));

    request.headers['Content-Type'] = 'application/json';

    request.body =
        json.encode({'resetToken': resetCode, 'new_password': newPassword});
    // var headers = {'Content-Type': 'application/json'};
    http.Response response =
        await http.Response.fromStream(await request.send());

    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      print('Status: ${data["status"]}, Message: ${data["message"]}');
      return data;
    } else {
      print('Error: ${response.statusCode}');
      return data;
    }
  }
}
