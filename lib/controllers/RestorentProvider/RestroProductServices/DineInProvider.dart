import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DineInProvider with ChangeNotifier {
  List<dynamic> billingFormats = [];
  List<dynamic> categories = [];
  List<Map<String, dynamic>> products = [];
  bool isLoading = false;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
///Fetch Kot Table
  Future<void> fetchKotTable() async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await _getToken();
      final response = await http.get(
        Uri.parse("https://apibrize.brizindia.com/api/kot-tables"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("fetchBillingFormats ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        billingFormats = decoded["tables"] ?? [];   // ✅ Safe null handling
        print("Parsed BillingFormats: $billingFormats");
      } else {
        billingFormats = [];
      }
    } catch (e) {
      if (kDebugMode) print("Error fetchBillingFormats: $e");
      billingFormats = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
// fetch Food Category
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

      print("fetchCategories ${response.body}");
      if (response.statusCode == 200) {
        categories = json.decode(response.body); // ✅ Array directly
      }
    } catch (e) {
      if (kDebugMode) print("Error fetchCategories: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
///fetch product
  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await _getToken();
      final response = await http.get(
        Uri.parse("https://apibrize.brizindia.com/api/product-and-service"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        // API se list aati hai [] form me
        products = List<Map<String, dynamic>>.from(decoded);
      } else {
        products = [];
      }
    } catch (e) {
      if (kDebugMode) print("Error fetchProducts: $e");
      products = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> bookTable(Map<String, dynamic> body) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse("https://apibrize.brizindia.com/api/book-family-tables"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",  // 👈 JWT token yahan lagao
          },
        body: json.encode(body),
      );

      print("fetchCategories${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) print("Error bookTable: $e");
      return false;
    }
  }
}
