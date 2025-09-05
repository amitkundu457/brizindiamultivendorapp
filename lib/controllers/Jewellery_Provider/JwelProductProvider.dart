import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/Jewellery_Model/BillingModel.dart'; // Import the Product model

class JwelProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool isLoading = true;

  List<Product> get products => _products;
  JwelProductProvider() {
    fetchProducts(); // ✅ automatically call when provider created
  }
  Future<void> fetchProducts() async {
    final url = 'https://apibrize.brizindia.com/api/product-services';
    try {
      // Fetch token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print('this is most wonderful tokensss $token');

      if (token == null) {
        print('Error: No token found');
        return;
      }

      // Make API request with the token
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Use the token from SharedPreferences
        },
      );

      if (response.statusCode == 200) {
        print('API Response: ${response.body}');
        List<dynamic> data = jsonDecode(response.body);
        _products = data.map((item) => Product.fromJson(item)).toList();
        // print('Parsed Products: ${_products.map((p) => p.name).toList()}');
        isLoading = false;
        notifyListeners();
      } else {
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching products: $error');
    }
  }
}
