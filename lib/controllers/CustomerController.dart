import '../models/CustomerModel.dart';
import '../services/customer_service.dart';

class CustomerController {
  static Future<Customer?> searchCustomer(String phone) async {
    return await CustomerService.fetchCustomerByPhone(phone);
  }

   static Future<List<dynamic>> fetchMemberships(int customerId) {
    return CustomerService.fetchMemberships(customerId);
  }
}
