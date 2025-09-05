import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'assigned_package.dart';

class PackageReportService {
  static Future<List<AssignedPackage>> fetchPackageReport({
    String? startDate,
    String? endDate,
    String? name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = Uri.parse(
      'https://apibrize.brizindia.com/api/package-report',
    ).replace(
      queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (name != null && name.isNotEmpty) 'name': name,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['assigned_packages'] ?? [];
      return items.map((e) => AssignedPackage.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load package report");
    }
  }
}
