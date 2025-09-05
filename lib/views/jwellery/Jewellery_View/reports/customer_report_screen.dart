import 'package:flutter/material.dart';

import '../../../../models/Jewellery_Model/customerReport.dart' show Customer;
import '../../../../services/customerReportService.dart';

class CustomerReportScreen extends StatefulWidget {
  final String title;
  const CustomerReportScreen({
    super.key,
    required this.title,
  });

  @override
  State<CustomerReportScreen> createState() => _CustomerReportScreenState();
}

class _CustomerReportScreenState extends State<CustomerReportScreen> {
  List<Customer> customers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    setState(() => isLoading = true);
    try {
      final data = await CustomerService.fetchCustomers();
      customers = data.map((e) => Customer.fromJson(e)).toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void openCustomerDetails(Customer customer) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(customer.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (customer.phone != null)
                Text("📞 ${customer.phone}",
                    style: const TextStyle(fontSize: 14)),
              if (customer.email != null)
                Text("✉️ ${customer.email}",
                    style: const TextStyle(fontSize: 14)),
              if (customer.address != null)
                Text("🏠 ${customer.address}",
                    style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              Text("Total Orders: ${customer.totalOrders}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.deepPurple)),
              if (customer.orderBillNos != null)
                Text("Orders: ${customer.orderBillNos}",
                    style: const TextStyle(fontSize: 13)),
              if (customer.orderTotals != null)
                Text("Amounts: ${customer.orderTotals}",
                    style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        itemCount: customers.length,
        separatorBuilder: (context, i) =>
            Divider(height: 1, color: Colors.grey[300]),
        itemBuilder: (context, i) {
          final customer = customers[i];
          return ListTile(
            title: Text(customer.name),
            subtitle: Text(customer.phone ?? "No phone"),
            trailing: Text(
              "Orders: ${customer.totalOrders}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () => openCustomerDetails(customer),
          );
        },
      ),
    );
  }
}
