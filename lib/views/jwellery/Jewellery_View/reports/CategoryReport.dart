import 'package:flutter/material.dart';
import '../../../../models/Jewellery_Model/CategoryReport.dart';
import '../../../../services/jwelCategoryReport.dart';

class CategoryReportScreen extends StatefulWidget {
  final String title;
  const CategoryReportScreen({super.key, required this.title,});

  @override
  State<CategoryReportScreen> createState() => _CategoryReportScreenState();
}

class _CategoryReportScreenState extends State<CategoryReportScreen> {
  List<CategoryReport> reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    setState(() => isLoading = true);
    try {
      final data = await CategoryReportService.fetchCategoryReports();
      setState(() => reports = data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📊 Category Reports"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
          ? const Center(child: Text("No reports found"))
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: reports.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              title: Text(
                report.category, // ✅ তোমার model field
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${report.name}"),
                  Text("Total Price: ₹${report.totalPrice.toStringAsFixed(2)}"),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Qty: ${report.qty}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500)),
                  Text(
                    "📅 ${report.createdAt.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
