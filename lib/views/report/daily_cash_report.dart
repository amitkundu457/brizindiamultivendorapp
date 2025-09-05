import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DailyCashReportScreen extends StatefulWidget {
  const DailyCashReportScreen({super.key});

  @override
  State<DailyCashReportScreen> createState() => _DailyCashReportScreenState();
}

class _DailyCashReportScreenState extends State<DailyCashReportScreen> {
  Map<String, dynamic>? summary;
  bool isLoading = false;
  String? error;

  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    fromDate = today.subtract(const Duration(days: 7));
    toDate = today;
    fetchSummary();
  }

  Future<void> fetchSummary() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(() {
          error = 'Token not found. Please login again.';
          isLoading = false;
        });
        return;
      }

      final from = fromDate!.toIso8601String().substring(0, 10);
      final to = toDate!.toIso8601String().substring(0, 10);
      final url =
          'https://apibrize.brizindia.com/api/cash-saloon?from_date=$from&to_date=$to';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final decoded = json.decode(response.body);

      print('Decoded response: $decoded');
      print('Type: ${decoded.runtimeType}');

      if (decoded is Map && decoded.containsKey('summary')) {
        setState(() {
          summary = decoded['summary'];
          isLoading = false;
        });
      } else if (decoded is List && decoded.isEmpty) {
        setState(() {
          error = 'No data available for selected date range.';
          isLoading = false;
        });
      } else if (decoded is List &&
          decoded.first is Map &&
          decoded.first.containsKey('summary')) {
        setState(() {
          summary = decoded.first['summary'];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Unexpected response format.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Something went wrong: $e';
        isLoading = false;
      });
    }
  }

  Future<void> pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: fromDate!, end: toDate!),
    );

    if (picked != null) {
      setState(() {
        fromDate = picked.start;
        toDate = picked.end;
      });
      await fetchSummary();
    }
  }

  Widget _buildSummaryCard(
    String label,
    int amount,
    Color color,
    IconData icon,
  ) {
    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 30),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        trailing: Text(
          '₹$amount',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Cash Report"),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: pickDateRange,
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "From: ${formatDate(fromDate!)}\nTo:   ${formatDate(toDate!)}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (summary != null) ...[
                    _buildSummaryCard(
                      "Cash",
                      summary!['cash'] ?? 0,
                      Colors.green.shade600,
                      Icons.attach_money,
                    ),
                    _buildSummaryCard(
                      "Card",
                      summary!['card'] ?? 0,
                      Colors.blue.shade700,
                      Icons.credit_card,
                    ),
                    _buildSummaryCard(
                      "UPI",
                      summary!['upi'] ?? 0,
                      Colors.purple.shade600,
                      Icons.qr_code,
                    ),
                  ],
                ],
              ),
    );
  }
}
