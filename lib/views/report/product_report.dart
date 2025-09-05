import 'package:flutter/material.dart';
import '../../models/product_model.dart';
// import '../../models/product_report_service.dart';
import 'package:intl/intl.dart';

import '../../services/product_report_service.dart';

class ProductReportScreen extends StatefulWidget {
  const ProductReportScreen({super.key});

  @override
  State<ProductReportScreen> createState() => _ProductReportScreenState();
}

class _ProductReportScreenState extends State<ProductReportScreen> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  final TextEditingController _nameController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await ProductReportService.fetchProducts();
      setState(() {
        allProducts = products;
        filteredProducts = products;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      filteredProducts = allProducts.where((product) {
        final productNameMatch = _nameController.text.isEmpty ||
            product.name.toLowerCase().contains(_nameController.text.toLowerCase());

        final productDate = DateTime.tryParse(product.createdAt ?? '');
        final startMatch = _startDate == null || (productDate != null && productDate.isAfter(_startDate!.subtract(const Duration(days: 1))));
        final endMatch = _endDate == null || (productDate != null && productDate.isBefore(_endDate!.add(const Duration(days: 1))));

        return productNameMatch && startMatch && endMatch;
      }).toList();
    });
  }

  void _resetFilters() {
    _nameController.clear();
    _startDate = null;
    _endDate = null;
    filteredProducts = List.from(allProducts);
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
      appBar: AppBar(title: const Text("Product Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
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
                  : filteredProducts.isEmpty
                  ? const Center(child: Text("No products found"))
                  : ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.code != null) Text("Code: ${product.code}"),
                          Text("Rate: ₹${product.rate ?? '0.00'}"),
                          Text("Tax: ${product.taxRate?.toString() ?? '0'}%"),
                          Text("Qty: ${product.qty?.toString() ?? '0'}"),
                          // Text("Created At: ${product.createdAt ?? 'N/A'}"),
                        ],
                      ),
                    )

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
