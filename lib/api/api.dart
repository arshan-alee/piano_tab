import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://ktswebhub.com/ppbl/api.php';

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    final url = Uri.parse('$baseUrl?signup');
    final response = await http.post(url, body: {'email': email, 'password': password});
    return jsonDecode(response.body);
  }


  //login_method can be google/apple/facebook
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl?login');
    final response = await http.post(url, body: {'email': email, 'password': password});
    return jsonDecode(response.body);
  }


  Future<Map<String, dynamic>> getCatalog() async {
    final url = Uri.parse('$baseUrl?catalog');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  //also if you want to bulk retreive you can add &points&library&catalog
  Future<Map<String, dynamic>> getUserData(String auth) async {
    final url = Uri.parse('$baseUrl?batch');
    final response = await http.post(url, body: {'auth': auth});
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updatePoints(String auth, int newPoints) async {
    final url = Uri.parse('$baseUrl?update_points');
    final response = await http.post(url, body: {'auth': auth, 'new_points': newPoints});
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateLibrary(String auth, String newLibrary) async {
    final url = Uri.parse('$baseUrl?update_library');
    final response = await http.post(url, body: {'auth': auth, 'new_library': newLibrary});
    return jsonDecode(response.body);
  }
}