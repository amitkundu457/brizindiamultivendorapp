import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/membership_report_model.dart';
import '../../services/membership_report_service.dart';

class MembershipReportScreen extends StatefulWidget {
  const MembershipReportScreen({super.key});

  @override
  State<MembershipReportScreen> createState() => _MembershipReportScreenState();
}

class _MembershipReportScreenState extends State<MembershipReportScreen> {
  List<MembershipReport> allReports = [];
  List<MembershipReport> filteredReports = [];
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _statusFilter = 'All'; // All, Active, Expired

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    try {
      final data = await MembershipReportService.fetchReports();
      setState(() {
        allReports = data;
        filteredReports = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    final query = _nameController.text.toLowerCase();
    setState(() {
      filteredReports = allReports.where((report) {
        final nameMatch = query.isEmpty || report.customer.name.toLowerCase().contains(query);
        final date = DateTime.tryParse(report.saleDate);
        final startMatch = _startDate == null || (date != null && date.isAfter(_startDate!.subtract(const Duration(days: 1))));
        final endMatch = _endDate == null || (date != null && date.isBefore(_endDate!.add(const Duration(days: 1))));
        final statusMatch = _statusFilter == 'All' || report.status == _statusFilter;
        return nameMatch && startMatch && endMatch && statusMatch;
      }).toList();
    });
  }

  void _resetFilters() {
    _nameController.clear();
    _startDate = null;
    _endDate = null;
    _statusFilter = 'All';
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
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Membership Report")),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _pickDate(context, true),
                    icon: const Icon(Icons.date_range),
                    label: Text(_startDate == null ? 'Start Date' : DateFormat('yyyy-MM-dd').format(_startDate!)),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _pickDate(context, false),
                    icon: const Icon(Icons.date_range),
                    label: Text(_endDate == null ? 'End Date' : DateFormat('yyyy-MM-dd').format(_endDate!)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text("Status: "),
                DropdownButton<String>(
                  value: _statusFilter,
                  items: ['All', 'Active', 'Expired']
                      .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _statusFilter = value);
                      _applyFilters();
                    }
                  },
                ),
                const Spacer(),
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
                  ? const Center(child: Text("No membership data found"))
                  : ListView.builder(
                itemCount: filteredReports.length,
                itemBuilder: (context, index) {
                  final report = filteredReports[index];
                  return Card(
                    child: ListTile(
                      title: Text(report.plan.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Customer: ${report.customer.name}"),
                          Text("Sale Date: ${report.saleDate}"),
                          Text("Expiry Date: ${report.expiryDate}"),
                          Text("Amount: ₹${report.amount}"),
                          Text("Status: ${report.status}"),
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
