import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../controllers/Jewellery_Provider/BillingReportProvider.dart';

class BillingReportScreen extends StatefulWidget {
  final String title;
  // const BillingReportScreen({Key? key}) : super(key: key);
  const BillingReportScreen({super.key, required this.title});
  @override
  State<BillingReportScreen> createState() => _BillingReportScreenState();
}

class _BillingReportScreenState extends State<BillingReportScreen> {
  final _phoneController = TextEditingController();
  final _billNoController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();

    // ✅ Default date range = last 10 days to today
    _endDate = DateTime.now();
    _startDate = DateTime.now().subtract(const Duration(days: 10));
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString("token");
    });
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _applyFilter() {
    if (_token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token not found! Please login again.")),
      );
      return;
    }

    final provider = Provider.of<BillingReportProvider>(context, listen: false);

    provider.fetchReports(
      token: _token!,
      startDate: _startDate != null ? DateFormat("yyyy-MM-dd").format(_startDate!) : null,
      endDate: _endDate != null ? DateFormat("yyyy-MM-dd").format(_endDate!) : null,
      customerPhone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      billNo: _billNoController.text.isNotEmpty ? _billNoController.text : null,
    );

    Navigator.pop(context); // ✅ close bottom sheet after applying
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Filter Reports",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Customer Phone",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _billNoController,
                decoration: const InputDecoration(
                  labelText: "Bill No",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(context, true),
                      child: Text(
                        _startDate == null
                            ? "Start Date"
                            : DateFormat("yyyy-MM-dd").format(_startDate!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(context, false),
                      child: Text(
                        _endDate == null
                            ? "End Date"
                            : DateFormat("yyyy-MM-dd").format(_endDate!),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _applyFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB8860B),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Apply Filter"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BillingReportProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Billing Reports"),
        backgroundColor: const Color(0xFFB8860B),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _openFilterSheet, // ✅ open filter popup
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.reports.isEmpty
          ? const Center(child: Text("No records found"))
          : ListView.builder(
        itemCount: provider.reports.length,
        itemBuilder: (context, index) {
          final report = provider.reports[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text("Bill No: ${report.billNo}"),
              subtitle: Text(
                "Customer: ${report.customerName}\n"
                    "Phone: ${report.customerPhone}\n"
                    "Date: ${report.billDate}",
              ),
              trailing: Text(
                "₹${report.totalPrice}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
