import 'package:flutter/material.dart';

import '../../models/service_report_modal.dart';
import '../../services/ServiceReportService.dart';


class ServiceReportScreen extends StatefulWidget {
  const ServiceReportScreen({super.key});

  @override
  State<ServiceReportScreen> createState() => _ServiceReportScreenState();
}

class _ServiceReportScreenState extends State<ServiceReportScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  List<ServiceModel> _allServices = [];
  List<ServiceModel> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoading = true);
    try {
      _allServices = await ServiceReportService.fetchServices();
      _applyFilters();
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
      _filteredServices = _allServices.where((service) {
        final nameMatch = _nameController.text.isEmpty ||
            service.name.toLowerCase().contains(_nameController.text.toLowerCase());

        final createdAt = DateTime.tryParse(service.createdAt);
        final startCheck = _startDate == null || (createdAt != null && createdAt.isAfter(_startDate!.subtract(const Duration(days: 1))));
        final endCheck = _endDate == null || (createdAt != null && createdAt.isBefore(_endDate!.add(const Duration(days: 1))));

        return nameMatch && startCheck && endCheck;
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
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

  void _resetFilters() {
    _nameController.clear();
    _startDate = null;
    _endDate = null;
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Service Name",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => _applyFilters(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(context, true),
                    icon: const Icon(Icons.date_range),
                    label: Text(_startDate == null
                        ? "Start Date"
                        : _startDate!.toIso8601String().split('T').first),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(context, false),
                    icon: const Icon(Icons.date_range),
                    label: Text(_endDate == null
                        ? "End Date"
                        : _endDate!.toIso8601String().split('T').first),
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
                    label: const Text("Apply Filter"),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredServices.isEmpty
                  ? const Center(child: Text("No services found"))
                  : ListView.builder(
                itemCount: _filteredServices.length,
                itemBuilder: (context, index) {
                  final service = _filteredServices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(service.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (service.description != null) Text("Description: ${service.description}"),
                          Text("Rate: ₹${service.rate}"),
                          Text("Created: ${service.createdAt.split('T').first}"),
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
