import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Jewellery_Model/CategoryReport.dart';


class CategoryReportService {
  static const String url = "https://apibrize.brizindia.com/api/categoryrate";

  static Future<List<CategoryReport>> fetchCategoryReports() async {
    try {
      // 🔑 Get token from local storage
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null || token.isEmpty) {
        throw Exception("Token not found. Please login again.");
      }

      // 🌐 API Call with token
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => CategoryReport.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load report: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching report: $e");
    }
  }
}
