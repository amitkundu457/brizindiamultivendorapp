import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/SaloonOrder.dart';

class GstReportService {
  static const String url =
      'https://apibrize.brizindia.com/api/saloon-order-cash';

  static Future<List<SaloonOrder>> fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception("Token not found");

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List orders = data['data'];
      return orders.map((e) => SaloonOrder.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }
}
