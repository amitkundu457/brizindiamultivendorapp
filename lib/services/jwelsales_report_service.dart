import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Jewellery_Model/sales_report.dart';

class SalesReportService {
  static const String baseUrl = "https://apibrize.brizindia.com/api/salesreport";

  static Future<List<SalesReport>> fetchSalesReport() async {

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
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => SalesReport.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load sales report: ${response.body}");
    }
  }
}
