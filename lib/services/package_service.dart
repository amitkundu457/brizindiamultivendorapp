import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/assigned_package.dart';
import '../models/package_item.dart';
import '../models/package_numbers.dart';

class PackageService {
  static Future<PackageNumbers?> getNextPackageNumbers() async {
    final url = Uri.parse(
      'https://apibrize.brizindia.com/api/packagesnext-numbers',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PackageNumbers.fromJson(data);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
    return null;
  }

  static Future<List<PackageItem>> fetchPackages() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('https://apibrize.brizindia.com/api/packagename');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => PackageItem.fromJson(item)).toList();
      } else {
        print("Failed to fetch packages: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching packages: $e");
    }

    return [];
  }

  /// ✅ Fetch assigned package for a customer
  static Future<Map<String, dynamic>?> submitPackageAssignment(
    int customerId,
    Map<String, dynamic> payload,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse(
      'https://apibrize.brizindia.com/api/packagesassign/$customerId',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );
      print("📦 Raw Response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        return data['data']; // 👈 only return the actual data part
      } else {
        print("❌ Failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("❌ Exception in submitPackageAssignment: $e");
    }

    return null;
  }

  static Future<Map<String, dynamic>?> fetchInvoiceData(int packageId) async {
    final url = Uri.parse(
      'https://apibrize.brizindia.com/api/printpackage/$packageId',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("❌ Failed to fetch invoice data: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching invoice: $e");
    }

    return null;
  }

  // static assignPackageToCustomer(Map<String, dynamic> payload) {}
}
