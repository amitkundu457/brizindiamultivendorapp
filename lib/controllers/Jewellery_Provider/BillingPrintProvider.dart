import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BillingPrintProvider with ChangeNotifier {
  // Default values for first name and role name
  String _firstName = "Sonu";
  String _roleName = "JEWELLERY";

  // Getter methods for first name and role name
  String get firstName => _firstName;
  String get roleName => _roleName;

  // Fields from the API
  String billNo = "";
  String invoiceDate = "";
  String grossTotal = "";
  String totalPrice = "";
  String discount = "";

  // Customer details
  String customerName = "";
  String customerPhone = "";
  String customerAddress = "";
  String customerPincode = "";
  String customerState = "";
  String customerCountry = "";

  // Tax and total calculations
  String cgst = "0"; // CGST percentage
  String sgst = "0"; // SGST percentage
  String totalWithTax = "N/A";

  // Product details
  List<Map<String, String?>> productDetails = [];

  /// Fetch tax rates from the API
  Future<void> fetchTaxRates() async {
    try {
      final response = await http.get(Uri.parse("https://api.equi.co.in/api/tax"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];

        // Extract CGST and SGST percentages
        cgst = data.firstWhere((item) => item['name'] == 'CGST')['amount'] ?? "0";
        sgst = data.firstWhere((item) => item['name'] == 'SGST')['amount'] ?? "0";

        // Recalculate total with taxes
        calculateTotalWithTax();
        notifyListeners();
      } else {
        print("Failed to fetch tax rates. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching tax rates: $error");
    }
  }

  /// Calculate the total amount with CGST and SGST
  void calculateTotalWithTax() {
    final gross = double.tryParse(grossTotal) ?? 0;
    final cgstAmount = (gross * (double.tryParse(cgst) ?? 0)) / 100;
    final sgstAmount = (gross * (double.tryParse(sgst) ?? 0)) / 100;

    totalWithTax = (gross + cgstAmount + sgstAmount).toStringAsFixed(2);
  }

  /// Fetch bill details and taxes, and calculate totals
  Future<void> fetchBillData() async {
    const url = "https://api.equi.co.in/api/printbill/23";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Parse API response into fields
        billNo = data["billno"] ?? "";
        invoiceDate = data["date"] ?? "";
        grossTotal = data["gross_total"] ?? "";
        totalPrice = data["total_price"] ?? "";
        discount = data["discount"] ?? "";

        // Parse customer details
        customerName = data["users"]?["name"] ?? "";
        customerPhone = data["users"]?["customers"]?[0]?["phone"] ?? "";
        customerAddress = data["users"]?["customers"]?[0]?["address"] ?? "";
        customerPincode = data["users"]?["customers"]?[0]?["pincode"] ?? "";
        customerState = data["users"]?["customers"]?[0]?["state"] ?? "";
        customerCountry = data["users"]?["customers"]?[0]?["country"] ?? "";

        // Parse product details
        productDetails = (data["details"] as List<dynamic>?)
            ?.map((detail) => {
          "productName": detail["product_name"] as String?,
          "grossWeight": detail["gross_weight"] as String?,
          "netWeight": detail["net_weight"] as String?,
          "making": detail["making"] as String?,
          "rate": detail["rate"] as String?,
          "total": detail["pro_total"] as String?,
        })
            .toList() ??
            [];

        // Fetch tax rates after fetching bill details
        await fetchTaxRates();

        notifyListeners();
      } else {
        print("Failed to fetch bill data. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching bill data: $error");
    }
  }

  /// Fetch first name and role from the user profile API
  Future<void> fetchUserProfile() async {
    try {
      final response = await http.get(Uri.parse('https://api.equi.co.in/api/auth/agme'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        _firstName = data['first name'] ?? "Sonu";
        _roleName = data['roles']['name'] ?? "JEWELLERY";

        notifyListeners();
      } else {
        print("Failed to fetch user profile. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching user profile: $error");
    }
  }
}
