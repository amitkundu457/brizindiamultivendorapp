import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/BarcodePrint.dart';
import '../../services/BarcodeReportService.dart';

class BarcodeReportScreen extends StatefulWidget {
  const BarcodeReportScreen({super.key});

  @override
  State<BarcodeReportScreen> createState() => _BarcodeReportScreenState();
}

class _BarcodeReportScreenState extends State<BarcodeReportScreen> {
  List<BarcodePrint> allData = [];
  List<BarcodePrint> filtered = [];
  bool _isLoading = true;
  String search = '';
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final res = await BarcodeReportService.fetchData();
      setState(() {
        allData = res;
        filtered = res;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void applyFilters() {
    setState(() {
      filtered = allData.where((item) {
        final nameMatch = item.product.name.toLowerCase().contains(search.toLowerCase());
        final printedDate = DateTime.tryParse(item.printedAt);
        final dateMatch = printedDate != null &&
            (startDate == null || printedDate.isAfter(startDate!.subtract(const Duration(days: 1)))) &&
            (endDate == null || printedDate.isBefore(endDate!.add(const Duration(days: 1))));
        return nameMatch && dateMatch;
      }).toList();
    });
  }

  void resetFilters() {
    setState(() {
      search = '';
      startDate = null;
      endDate = null;
      searchController.clear();
      filtered = allData;
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
      appBar: AppBar(title: const Text("Barcode Report")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search by product name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                search = val;
                applyFilters();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: pickDateRange,
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: const Text("Date Filter"),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: resetFilters,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                ),
              ],
            ),
          ),
          if (startDate != null && endDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                "Filtered: ${DateFormat('yyyy-MM-dd').format(startDate!)} to ${DateFormat('yyyy-MM-dd').format(endDate!)}",
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          const Divider(),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("No matching records"))
                : ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text("Product: ${item.product.name}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Barcode: ${item.barcode.barcodeNo}"),
                        Text("Printed by: ${item.user.name}"),
                        Text("Printed at: ${item.printedAt}"),
                      ],
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
