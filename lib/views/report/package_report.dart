import 'package:flutter/material.dart';
import '../../models/assigned_package.dart';
import '../../models/package_report_service.dart';

class PackageReportScreen extends StatefulWidget {
  const PackageReportScreen({super.key});

  @override
  State<PackageReportScreen> createState() => _PackageReportScreenState();
}

class _PackageReportScreenState extends State<PackageReportScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  bool _isLoading = false;
  List<AssignedPackage> _allPackages = [];
  List<AssignedPackage> _filteredPackages = [];

  @override
  void initState() {
    super.initState();
    _fetchAllReports();
  }

  Future<void> _fetchAllReports() async {
    setState(() => _isLoading = true);

    try {
      final results = await PackageReportService.fetchPackageReport();
      setState(() {
        _allPackages = results;
        _applyLocalFilters(); // apply filter on load
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyLocalFilters() {
    final nameFilter = _nameController.text.trim().toLowerCase();

    final filtered = _allPackages.where((pkg) {
      final matchesName = nameFilter.isEmpty ||
          (pkg.user?.name?.toLowerCase().contains(nameFilter) ?? false);

      final bookingDate = DateTime.tryParse(pkg.packageBooking);
      final matchesStartDate = _startDate == null ||
          (bookingDate != null && !bookingDate.isBefore(_startDate!));
      final matchesEndDate = _endDate == null ||
          (bookingDate != null && !bookingDate.isAfter(_endDate!));

      return matchesName && matchesStartDate && matchesEndDate;
    }).toList();

    setState(() => _filteredPackages = filtered);
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
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
      _applyLocalFilters();
    }
  }

  void _resetFilters() {
    _nameController.clear();
    _startDate = null;
    _endDate = null;
    _applyLocalFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Package Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Filter Inputs
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Customer Name",
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (_) => _applyLocalFilters(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(context, true),
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _startDate == null
                          ? "Start Date"
                          : _startDate!.toIso8601String().split('T').first,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(context, false),
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _endDate == null
                          ? "End Date"
                          : _endDate!.toIso8601String().split('T').first,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _applyLocalFilters,
                    icon: const Icon(Icons.search),
                    label: const Text("Search"),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 📦 Results
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredPackages.isEmpty
                  ? const Center(child: Text("No reports found"))
                  : ListView.builder(
                itemCount: _filteredPackages.length,
                itemBuilder: (context, index) {
                  final pkg = _filteredPackages[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text("Customer: ${pkg.user?.name ?? 'Unknown'}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Package No: ${pkg.packageNo}"),
                          Text("Amount: ₹${pkg.packageAmount}, Paid: ₹${pkg.paidAmount}"),
                          Text("Booking: ${pkg.packageBooking}, Expiry: ${pkg.packageExpiry}"),
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
