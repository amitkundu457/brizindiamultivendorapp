import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BillingOrderProvider with ChangeNotifier {
  // Function to create an order
  Future<bool> createOrder(BuildContext context, Map<String, dynamic> payload) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed: Token missing')),
        );
        return false;
      }

      // Log the payload for debugging
      print('Sending payload: ${jsonEncode(payload)}');

      final response = await http.post(
        Uri.parse('https://apibrize.brizindia.com/api/order'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      // Handle different status codes
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        print('Response Data: $responseData');
        if (responseData.containsKey('order_id')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                'Order created successfully! Order ID: ${responseData['order_id']}')),
          );
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                'Order creation failed, order_id missing in response!')),
          );
          return false;
        }
      } else if (response.statusCode == 422) {
        // Handle 422 validation error
        print('Error 422: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Validation error: ${response.body}')),
        );
        return false;
      } else {
        // Handle other errors
        print("Error ${response.statusCode}: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
              'Error ${response.statusCode}: ${response.reasonPhrase}')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }

  // // Function to fetch customer_id by phone
  // Future<int?> fetchCustomerId(String phone, BuildContext context) async {
  //   final phone=123456789;
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final String? token = prefs.getString('accessToken');
  //
  //     if (token == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Authentication failed: Token missing')),
  //       );
  //       return null;
  //     }
  //
  //     final response = await http.get(
  //       Uri.parse('https://api.equi.co.in/api/customers/search?phone=$phone'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //
  //       if (data['customer_id'] != null) {
  //         return data['customer_id']; // Return the customer_id
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Customer not found')),
  //         );
  //         return null;
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: ${response.reasonPhrase}')),
  //       );
  //       return null;
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error fetching customer: $e')),
  //     );
  //     return null;
  //   }
  // }
  // Function to fetch customer details (name and address) by phone number
  Future<Map<String, dynamic>?> fetchCustomerDetails(String phone,
      BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed: Token missing')),
        );
        return null;
      }

      final response = await http.get(
        Uri.parse('https://apibrize.brizindia.com/api/customers/search?phone=$phone'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if the response contains 'name', 'address', and 'id'
        if (data['name'] != null && data['address'] != null &&
            data['id'] != null) {
          // Return customer details as a Map
          return {
            'id': data['id'],
            'name': data['name'],
            'address': data['address'],
          };
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Customer not found or invalid phone number!')),
          );
          return null;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching customer: $e')),
      );
      return null;
    }
  }

}






// class OrderProvider with ChangeNotifier {
//   Future<bool> createOrder(BuildContext context, Map<String, dynamic> payload) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('accessToken');
//
//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Authentication failed: Token missing')),
//         );
//         return false;  // Return false if token is missing
//       }
//
//       final response = await http.post(
//         Uri.parse('https://api.equi.co.in/api/order'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(payload),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         var responseData = jsonDecode(response.body);
//
//         // Debugging: Print the entire response body
//         print('Response Data: $responseData');
//
//         // Handle response and check for 'order_id'
//         if (responseData.containsKey('order_id')) {
//           String orderId = responseData['order_id'].toString();
//
//           if (orderId.isNotEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Order created successfully! Order ID: $orderId')),
//             );
//             return true;
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Order creation failed, order_id is empty!')),
//             );
//             return false;
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Order creation failed, order_id missing in response!')),
//           );
//           return false;
//         }
//       } else {
//         // Handle other errors (non-200 status codes)
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${response.statusCode}')),
//         );
//         return false;
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//       return false;  // Return false if there's any error
//     }
//   }
// }
