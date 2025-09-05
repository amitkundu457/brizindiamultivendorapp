import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/CustomerModel.dart';
// import '../models/customer_model.dart';

class CustomerService {
  static Future<Customer?> fetchCustomerByPhone(String phone) async {
    try {
      final url = Uri.parse(
        "https://apibrize.brizindia.com/api/customers/search/?phone=$phone",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Customer.fromJson(data);
      } else {
        print('Failed to load customer: ${response.body}');
      }
    } catch (e) {
      print("Exception: $e");
    }
    return null;
  }

  static Future<List<dynamic>> fetchMemberships(int customerId) async {
    try {
      final url = Uri.parse(
        "https://apibrize.brizindia.com/api/memberships/$customerId",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print('Failed to load memberships: ${response.body}');
      }
    } catch (e) {
      print("Exception while fetching memberships: $e");
    }
    return [];
  }
}
