import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:paino_tab/models/LoginModel.dart';
import 'package:paino_tab/models/UserDataModel.dart';
import 'package:paino_tab/models/localdbmodels/LoginBox.dart';
import 'package:paino_tab/models/localdbmodels/UserDataBox.dart';

class ApiService {
  static const String baseUrl = 'https://www.ktswebhub.com/ppbl/api.php';

  static Future<Map<String, dynamic>> signUp(
      String email, String password) async {
    var request = http.Request('POST', Uri.parse('${baseUrl}?signup'));
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
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('${baseUrl}?login'));
      request.body = json.encode({"email": email, "password": password});
      request.headers.addAll(headers);

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
    final url = Uri.parse('$baseUrl?catalog');
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
      print("$baseUrl?batch&library&points");
      // var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse('$baseUrl?batch&library&points'));
      request.body = json.encode({"auth": auth});
      // request.headers.addAll(headers);

      http.Response response =
          await http.Response.fromStream(await request.send());
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

// Check if the response contains the "data" field
      if (jsonResponse.containsKey("data")) {
        var data = jsonResponse["data"];
        print("hellojee");
        // Use the UserModelFromJson function to create a UserData object
        var userData = UserModelFromJson(jsonEncode(data));

        var userBox = UserDataBox.userBox!;
        if (userBox.values.isNotEmpty) {
          await userBox.clear();
        }
        await userBox.add(userData);

        return true;
      } else {
        print("Error: 'data' field not found in the response.");
        return false;
      }
    } catch (e) {
      print("Error in storing userdata in userdatabox $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>> updatePoints(
      String auth, int newPoints) async {
    final url = Uri.parse('$baseUrl?update_points');
    final response =
        await http.post(url, body: {'auth': auth, 'new_points': newPoints});
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateLibrary(
      String auth, String newLibrary) async {
    final url = Uri.parse('$baseUrl?update_library');
    final response =
        await http.post(url, body: {'auth': auth, 'new_library': newLibrary});
    return jsonDecode(response.body);
  }
}
