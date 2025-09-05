import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ProductStock.dart';
// import '../models/product_stock_model.dart';

class StockReportService {
  static Future<List<ProductStock>> fetchStocks() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
        "https://apibrize.brizindia.com/api/product-service-saloon?pro_ser_type=Product",
      ),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProductStock.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch stock data");
    }
  }
}
