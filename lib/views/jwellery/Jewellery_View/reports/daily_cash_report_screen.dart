import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/Jewellery_Model/payment_summary.dart';
import '../../../../services/payment_report_service.dart';

class DailyCashReportScreen extends StatefulWidget {
  final String title;
  const DailyCashReportScreen({super.key, required this.title});

  @override
  State<DailyCashReportScreen> createState() => _DailyCashReportScreenState();
}

class _DailyCashReportScreenState extends State<DailyCashReportScreen> {
  PaymentSummary? summary;
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime toDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchSummary();
  }

  Future<void> fetchSummary() async {
    final fetchedSummary = await PaymentReportService.fetchSummary(
      DateFormat('yyyy-MM-dd').format(fromDate),
      DateFormat('yyyy-MM-dd').format(toDate),
    );

    setState(() {
      summary = fetchedSummary;
    });
  }

  /// ✅ Summary Card
  Widget buildSummaryTile(String label, int amount, Color color, IconData icon) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 28),
        title: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          "₹$amount",
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// ✅ Date Range Picker
  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: fromDate, end: toDate),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        fromDate = picked.start;
        toDate = picked.end;
      });
      fetchSummary(); // ✅ Refresh data after picking date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Cash Report"),
        backgroundColor: const Color(0xFFB8860B), // ✅ Golden Brown
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pickDateRange, // ✅ Connected
          )
        ],
      ),
      body: summary == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("From: ${DateFormat('yyyy-MM-dd').format(fromDate)}"),
            Text("To: ${DateFormat('yyyy-MM-dd').format(toDate)}"),
            const SizedBox(height: 20),
            buildSummaryTile("Cash", summary!.cash, Colors.green, Icons.attach_money),
            buildSummaryTile("Card", summary!.card, Colors.blue, Icons.credit_card),
            buildSummaryTile("UPI", summary!.upi, Colors.purple, Icons.qr_code),
            buildSummaryTile("Advance", summary!.advance, Colors.orange, Icons.payment),
            buildSummaryTile("Others", summary!.others, Colors.grey, Icons.more_horiz),
          ],
        ),
      ),
    );
  }
}
