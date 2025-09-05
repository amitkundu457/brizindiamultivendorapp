import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/BarcodePrint.dart';

class BarcodeReportService {
  static const String apiUrl =
      'https://apibrize.brizindia.com/api/barcode-print-history';

  static Future<List<BarcodePrint>> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print(response);
      final body = jsonDecode(response.body);
      final List data = jsonDecode(response.body);
      return data.map((e) => BarcodePrint.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load barcode data');
    }
  }
}
