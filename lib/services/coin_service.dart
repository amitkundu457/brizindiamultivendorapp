import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/coin_model.dart';

class CoinService {
  static const String coinUrl = "https://apibrize.brizindia.com/api/coinid";

  static Future<CoinData> fetchCoins() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse(coinUrl),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CoinData.fromJson(data);
    } else {
      throw Exception('Failed to fetch coin data');
    }
  }
}
