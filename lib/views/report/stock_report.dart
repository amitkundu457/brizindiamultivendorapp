import 'package:flutter/material.dart';
import '../../models/ProductStock.dart';
import '../../services/StockReportService.dart';

class StockReportScreen extends StatefulWidget {
  const StockReportScreen({super.key});

  @override
  State<StockReportScreen> createState() => _StockReportScreenState();
}

class _StockReportScreenState extends State<StockReportScreen> {
  List<ProductStock> allProducts = [];
  List<ProductStock> filteredProducts = [];

  String stockFilter = 'All'; // All, In Stock, Out of Stock
  TextEditingController nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStock();
  }

  Future<void> _loadStock() async {
    setState(() => _isLoading = true);
    try {
      final data = await StockReportService.fetchStocks();
      setState(() {
        allProducts = data;
        filteredProducts = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    final query = nameController.text.toLowerCase();
    setState(() {
      filteredProducts =
          allProducts.where((product) {
            final matchesName =
                query.isEmpty || product.name.toLowerCase().contains(query);
            final matchesStock =
                stockFilter == 'All' ||
                (stockFilter == 'In Stock' && product.currentStock > 0) ||
                (stockFilter == 'Out of Stock' && product.currentStock == 0);
            return matchesName && matchesStock;
          }).toList();
    });
  }

  void _resetFilters() {
    nameController.clear();
    stockFilter = 'All';
    filteredProducts = List.from(allProducts);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stock Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => _applyFilters(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Stock: "),
                DropdownButton<String>(
                  value: stockFilter,
                  items:
                      ['All', 'In Stock', 'Out of Stock']
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        stockFilter = value;
                      });
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
            const SizedBox(height: 10),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredProducts.isEmpty
                      ? const Center(child: Text("No stock data found"))
                      : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          final stockStatus =
                              product.currentStock == 0
                                  ? "Out of Stock"
                                  : "In Stock: ${product.currentStock}";

                          final imageUrl =
                              (product.image != null && product.image != 'null')
                                  ? "https://apibrize.brizindia.com/storage/${product.image}"
                                  : null;

                          return Card(
                            child: ListTile(
                              leading:
                                  imageUrl != null
                                      ? Image.network(
                                        imageUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return const SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Center(
                                              child: Text(
                                                "No Image",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                      : const SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Center(
                                          child: Text(
                                            "No Image",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ),
                              title: Text(product.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Rate: ₹${product.rate ?? '0.00'}"),
                                  Text(
                                    stockStatus,
                                    style: TextStyle(
                                      color:
                                          product.currentStock == 0
                                              ? Colors.red
                                              : Colors.green,
                                    ),
                                  ),
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
