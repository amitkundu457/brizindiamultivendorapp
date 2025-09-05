import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Jewellery_Model/PartialReportModal.dart';


class PartialOrderService {
  static const String baseUrl =
      "https://apibrize.brizindia.com/api/partial-order";

  static Future<List<OrderData>> fetchPartialOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final data = PartialOrderResponse.fromJson(jsonResponse);
      return data.data;
    } else {
      throw Exception("Failed to load partial orders: ${response.body}");
    }
  }
}
