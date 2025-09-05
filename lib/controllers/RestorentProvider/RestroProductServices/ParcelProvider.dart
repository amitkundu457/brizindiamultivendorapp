import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ParcelProvider with ChangeNotifier {
  List<dynamic> parcelTypes = [];
  List<dynamic> categories = [];
  bool isLoading = false;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token"); // 👈 token storage
  }

  Future<void> fetchParcelTypes() async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await _getToken();
      final response = await http.get(
        Uri.parse("https://apibrize.brizindia.com/api/parcel-types"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Parcel Types: ${response.body}");

      if (response.statusCode == 200) {
        parcelTypes = json.decode(response.body);
      }
    } catch (e) {
      if (kDebugMode) print("Error fetchParcelTypes: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await _getToken();
      final response = await http.get(
        Uri.parse("https://apibrize.brizindia.com/api/type"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Kot Tables: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          categories = data; // ✅ direct assign
        } else {
          categories = []; // fallback
        }
      }
    } catch (e) {
      if (kDebugMode) print("Error fetchCategories: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
