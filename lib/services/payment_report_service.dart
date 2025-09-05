import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Jewellery_Model/payment_summary.dart';

class PaymentReportService {
  static Future<PaymentSummary?> fetchSummary(String fromDate, String toDate) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final url = Uri.parse(
        'https://apibrize.brizindia.com/api/paymenetreport?from_date=$fromDate&to_date=$toDate',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Response: $data");

        final summaryData = data['summary'];

        if (summaryData is Map<String, dynamic>) {
          // ✅ Case 1: summary is an object
          return PaymentSummary.fromJson(summaryData);
        } else if (summaryData is List && summaryData.isNotEmpty) {
          // ✅ Case 2: summary is a list
          return PaymentSummary.fromJson(summaryData.first);
        } else {
          print("⚠️ Summary empty");
          return null;
        }
      } else {
        print("❌ Error: ${response.statusCode} => ${response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Exception: $e");
      return null;
    }
  }
}
