import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/assigned_package.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/stylist_model.dart';

class ProductService {
  static const String baseUrl =
      "https://apibrize.brizindia.com/api/product-service-saloon";

  static const String categoryUrl = "https://apibrize.brizindia.com/api/type";
  static const String stylistUrl =
      "https://apibrize.brizindia.com/api/stylists";

  static Future<List<Product>> fetchProducts({
    String? type,
    String? category,
    String? search,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception("Token not found");

    final queryParams = {
      if (type != null && type.isNotEmpty) 'pro_ser_type': type,
      if (category != null && category.isNotEmpty) 'category': category,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to fetch product data");
    }
  }

  static Future<List<Category>> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception("Token not found");

    final response = await http.get(
      Uri.parse(categoryUrl),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      // 🟡 Print the raw response
      print("Fetched category data: $jsonList");

      // 🟡 Optional: print each category name if present
      for (var item in jsonList) {
        print("Category Name: ${item['name']}"); // ✅ CORRECT
      }

      return jsonList.map((e) => Category.fromJson(e)).toList();
    } else {
      print("Error response: ${response.body}");
      throw Exception("Failed to fetch categories");
    }
  }

  static Future<List<Stylist>> fetchStylists() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception("Token not found");

    final response = await http.get(
      Uri.parse(stylistUrl),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Stylist.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch stylists");
    }
  }

  static Future<String> fetchBillNo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('https://apibrize.brizindia.com/api/bill-no'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Response is plain text (not JSON), so return body directly
        return response.body.trim(); // Trim removes unwanted newlines/spaces
      } else {
        print('❌ Failed to fetch bill no: ${response.body}');
        return 'N/A';
      }
    } catch (e) {
      print('❌ Error fetching bill no: $e');
      return 'N/A';
    }
  }

  static Future<AssignedPackage?> fetchAssignedPackage(int customerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final url = Uri.parse(
      'https://apibrize.brizindia.com/api/packagesassign/$customerId',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AssignedPackage.fromJson(data);
      } else {
        print('Failed: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }
}
