import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart'; // <-- use the model here

class AuthService {
  static const String loginUrl = "https://apibrize.brizindia.com/api/login";
  static const String userUrl = "https://apibrize.brizindia.com/api/auth/agme";

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        print(token);
        print(response);
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  static Future<User> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('No token found');
      throw Exception('No token found');
    }

    print("Using token: $token");

    final response = await http.get(
      Uri.parse(userUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Parsed name: ${data['user']['name']}");
      return User.fromJson(data['user']);
    } else {
      print("Failed to fetch user: ${response.body}");
      throw Exception('Failed to fetch user');
    }
  }
}
