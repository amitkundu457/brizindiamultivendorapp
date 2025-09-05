import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/SaloonOrder.dart';
import '../../services/GstReportService.dart';

class GSTReportScreen extends StatefulWidget {
  const GSTReportScreen({super.key});

  @override
  State<GSTReportScreen> createState() => _GSTReportScreenState();
}

class _GSTReportScreenState extends State<GSTReportScreen> {
  List<SaloonOrder> allOrders = [];
  List<SaloonOrder> filteredOrders = [];
  bool _isLoading = true;
  String searchQuery = '';
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final orders = await GstReportService.fetchOrders();
      setState(() {
        allOrders = orders;
        filteredOrders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  void applyFilters() {
    setState(() {
      filteredOrders = allOrders.where((order) {
        final matchBill = order.billNo.toLowerCase().contains(searchQuery.toLowerCase());
        final orderDate = DateTime.tryParse(order.date);
        final withinDateRange = orderDate != null &&
            (startDate == null || orderDate.isAfter(startDate!.subtract(const Duration(days: 1)))) &&
            (endDate == null || orderDate.isBefore(endDate!.add(const Duration(days: 1))));
        return matchBill && withinDateRange;
      }).toList();
    });
  }

  void resetFilters() {
    setState(() {
      searchQuery = '';
      searchController.clear();
      startDate = null;
      endDate = null;
      filteredOrders = allOrders;
    });
  }

  Future<void> pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        applyFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GST Report")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Bill No',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                searchQuery = val;
                applyFilters();
              },
            ),
          ),

          // Date Filter and Reset Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: pickDateRange,
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: const Text("Date Filter"),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: resetFilters,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                ),
              ],
            ),
          ),

          // Filtered Range Display
          if (startDate != null && endDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                "Filtered: ${DateFormat('yyyy-MM-dd').format(startDate!)} to ${DateFormat('yyyy-MM-dd').format(endDate!)}",
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),

          const SizedBox(height: 6),

          // List View
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(child: Text("No matching records"))
                : ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bill No: ${order.billNo}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text("Date: ${order.date}"),
                          Text("Total: ₹${order.totalPrice}"),
                          Text("Gross: ₹${order.grossTotal}, Discount: ₹${order.discount}"),
                          Text("User: ${order.userName}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
