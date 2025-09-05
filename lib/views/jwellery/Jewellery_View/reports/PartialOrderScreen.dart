import 'package:flutter/material.dart';

import '../../../../models/Jewellery_Model/PartialReportModal.dart';
import '../../../../services/Partial_services.dart';

class PartialOrderScreen extends StatefulWidget {
  final String title;
  const PartialOrderScreen({super.key, required this.title});

  @override
  State<PartialOrderScreen> createState() => _PartialOrderScreenState();
}

class _PartialOrderScreenState extends State<PartialOrderScreen> {
  List<OrderData> orders = [];
  List<OrderData> filteredOrders = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    setState(() => isLoading = true);
    try {
      final data = await PartialOrderService.fetchPartialOrders();
      setState(() {
        orders = data;
        filteredOrders = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void filterOrders(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredOrders = orders.where((order) {
        final bill = order.billno.toLowerCase();
        final name = order.user?.name.toLowerCase() ?? "";
        return bill.contains(searchQuery) || name.contains(searchQuery);
      }).toList();
    });
  }

  void openOrderDetails(OrderData order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text("Bill No: ${order.billno}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Customer: ${order.user?.name ?? 'N/A'}"),
                Text("Date: ${order.date}"),
                const SizedBox(height: 12),

                const Text("🛒 Products:",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...order.details.map((d) => ListTile(
                  title: Text(d.productName),
                  subtitle: Text("Qty: ${d.qty} • Rate: ₹${d.rate}"),
                  trailing: Text("₹${d.proTotal}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                )),

                const SizedBox(height: 12),
                const Text("💳 Payments:",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...order.payments.map((p) => ListTile(
                  title: Text(p.paymentMethod.toUpperCase()),
                  trailing: Text("₹${p.price}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Date: ${p.paymentDate}"),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text("Partial Orders"), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // 🔍 Search Box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search by Bill No or Customer Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: filterOrders,
            ),
          ),

          Expanded(
            child: ListView.separated(
              itemCount: filteredOrders.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey[300]),
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return ListTile(
                  title: Text("Bill: ${order.billno}"),
                  subtitle:
                  Text("Customer: ${order.user?.name ?? 'N/A'}"),
                  trailing: Text("₹${order.totalPrice}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple)),
                  onTap: () => openOrderDetails(order),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
