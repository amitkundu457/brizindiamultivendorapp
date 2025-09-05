import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/saloon_order_cash_model.dart';
import '../../services/bill_report_service.dart';

class BillReportScreen extends StatefulWidget {
  const BillReportScreen({super.key});

  @override
  State<BillReportScreen> createState() => _BillReportScreenState();
}

class _BillReportScreenState extends State<BillReportScreen> {
  List<BillReport> allReports = [];
  List<BillReport> filteredReports = [];
  final TextEditingController _nameController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    try {
      final data = await BillReportService.fetchReports();
      setState(() {
        allReports = data;
        filteredReports = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      filteredReports = allReports.where((report) {
        final nameMatch = _nameController.text.isEmpty ||
            report.customerName
                .toLowerCase()
                .contains(_nameController.text.toLowerCase());

        final createdAt = DateTime.tryParse(report.createdAt);
        final startMatch = _startDate == null ||
            (createdAt != null && createdAt.isAfter(_startDate!.subtract(const Duration(days: 1))));
        final endMatch = _endDate == null ||
            (createdAt != null && createdAt.isBefore(_endDate!.add(const Duration(days: 1))));

        return nameMatch && startMatch && endMatch;
      }).toList();
    });
  }

  void _resetFilters() {
    _nameController.clear();
    _startDate = null;
    _endDate = null;
    filteredReports = List.from(allReports);
    setState(() {});
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bill Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => _applyFilters(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _pickDate(context, true),
                    icon: const Icon(Icons.calendar_month),
                    label: Text(_startDate == null
                        ? "Start Date"
                        : DateFormat('yyyy-MM-dd').format(_startDate!)),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _pickDate(context, false),
                    icon: const Icon(Icons.calendar_month),
                    label: Text(_endDate == null
                        ? "End Date"
                        : DateFormat('yyyy-MM-dd').format(_endDate!)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _applyFilters,
                    icon: const Icon(Icons.filter_alt),
                    label: const Text("Apply"),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredReports.isEmpty
                  ? const Center(child: Text("No bill reports found"))
                  : ListView.builder(
                itemCount: filteredReports.length,
                itemBuilder: (context, index) {
                  final report = filteredReports[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text("Invoice: ${report.invoiceNo}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Customer: ${report.customerName}"),
                          Text("Payment: ${report.paymentMethod}"),
                          Text("Amount: ₹${report.totalAmount}"),
                          Text("Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(report.createdAt))}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
