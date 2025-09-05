import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Jewellery_Model/gstreport.dart';

class GstService {
  static const String apiUrl = "https://apibrize.brizindia.com/api/gstReport";

  static Future<List<GstInvoice>> fetchGstInvoices() async {
    // 🔹 Get JWT token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    if (token.isEmpty) {
      throw Exception("JWT token not found");
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => GstInvoice.fromJson(e)).toList();
    } else {
      throw Exception(
          "Failed to load GST data: ${response.statusCode} - ${response.reasonPhrase}");
    }
  }
}
