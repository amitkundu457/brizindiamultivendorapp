import 'package:flutter/material.dart';
import '../../../../models/Jewellery_Model/sales_report.dart';
import '../../../../services/jwelsales_report_service.dart';
// import '../../../../services/sales_report_service.dart';

class SalesReportScreen extends StatefulWidget {
  final String title;
  const SalesReportScreen({super.key, required this.title});
  // const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  List<SalesReport> allReports = [];
  List<SalesReport> filteredReports = [];
  String? selectedProduct;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    try {
      final reports = await SalesReportService.fetchSalesReport();
      setState(() {
        allReports = reports;
        if (allReports.isNotEmpty) {
          selectedProduct = allReports.first.productName;
          filterReports();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void filterReports() {
    setState(() {
      filteredReports =
          allReports.where((r) => r.productName == selectedProduct).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productList =
    allReports.map((e) => e.productName).toSet().toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Sales Report"), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          if (productList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedProduct,
                decoration: const InputDecoration(
                  labelText: "Filter by Product",
                  border: OutlineInputBorder(),
                ),
                items: productList
                    .map((prod) => DropdownMenuItem(
                  value: prod,
                  child: Text(prod),
                ))
                    .toList(),
                onChanged: (value) {
                  selectedProduct = value;
                  filterReports();
                },
              ),
            ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredReports.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey[300]),
              itemBuilder: (context, i) {
                final report = filteredReports[i];
                return ListTile(
                  title: Text("Bill: ${report.billno}"),
                  subtitle: Text(
                    "Customer: ${report.customerName} • Date: ${report.paymentDate}",
                  ),
                  trailing: Text(
                    "${report.paymentMethod} - ₹${report.price}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
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
