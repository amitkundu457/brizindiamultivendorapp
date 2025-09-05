import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ProductItem.dart';

class ProductExpiryService {
  static const String url =
      'https://apibrize.brizindia.com/api/product-service-saloon';

  static Future<List<ProductItem>> fetchItems() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ProductItem.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch product data");
    }
  }
}
