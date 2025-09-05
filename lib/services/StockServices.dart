import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Jewellery_Model/StockReport.dart';
// import '../models/stock_model.dart';

class StockService {
  static const String baseUrl = "https://apibrize.brizindia.com/api/stockDetails";

  static Future<List<StockItem>> fetchStock() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      throw Exception("No token found. Please login again.");
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => StockItem.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load stock: ${response.body}");
    }
  }
}
