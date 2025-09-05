import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/Jewellery_Model/billingReport.dart';

class BillingReportProvider with ChangeNotifier {
  List<BillingReport> _reports = [];
  bool isLoading = false;

  List<BillingReport> get reports => _reports;

  Future<void> fetchReports({
    required String token,
    String? startDate,
    String? endDate,
    String? customerPhone,
    String? billNo,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      // ✅ Build query params
      final queryParams = <String, String>{};
      if (startDate != null && startDate.isNotEmpty) queryParams["start_date"] = startDate;
      if (endDate != null && endDate.isNotEmpty) queryParams["end_date"] = endDate;
      if (customerPhone != null && customerPhone.isNotEmpty) queryParams["customer_phone"] = customerPhone;
      if (billNo != null && billNo.isNotEmpty) queryParams["billno"] = billNo;

      final uri = Uri.https(
        "apibrize.brizindia.com",
        "/api/billingPurchase",
        queryParams.isEmpty ? null : queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic> && decoded.containsKey("data")) {
          final List<dynamic> data = decoded["data"];
          _reports = data.map((e) => BillingReport.fromJson(e)).toList();
        } else if (decoded is List) {
          _reports = decoded.map((e) => BillingReport.fromJson(e)).toList();
        } else {
          _reports = [];
          print("⚠️ Unexpected response format: $decoded");
        }
      } else {
        _reports = [];
      }
    } catch (e) {
      print("❌ Error: $e");
      _reports = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
