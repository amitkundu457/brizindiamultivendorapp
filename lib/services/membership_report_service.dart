import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/membership_report_model.dart';

class MembershipReportService {
  static Future<List<MembershipReport>> fetchReports() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("https://apibrize.brizindia.com/api/membership-sales-report"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => MembershipReport.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch membership reports");
    }
  }
}
