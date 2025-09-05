import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Jewellery_Model/productReport.dart';

class jwelProductReportService {
  static Future<List<ProductReport>> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = Uri.parse("https://apibrize.brizindia.com/api/product-services");
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
 print(response);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProductReport.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch product data");
    }
  }
}
