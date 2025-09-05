import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saloon_order_cash_model.dart';

class BillReportService {
  static Future<List<BillReport>> fetchReports() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("https://apibrize.brizindia.com/api/saloon-order-cash"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List data = jsonResponse['data'];
      return data.map((e) => BillReport.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch bill reports");
    }
  }
}
