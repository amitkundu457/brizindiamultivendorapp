import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/ProductItem.dart';
import '../../services/ProductExpiryService.dart';

class ProductExpiryReportScreen extends StatefulWidget {
  const ProductExpiryReportScreen({super.key});

  @override
  State<ProductExpiryReportScreen> createState() =>
      _ProductExpiryReportScreenState();
}

class _ProductExpiryReportScreenState extends State<ProductExpiryReportScreen> {
  List<ProductItem> allProducts = [];
  List<ProductItem> filteredProducts = [];
  bool _loading = true;

  String search = '';
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final result = await ProductExpiryService.fetchItems();
      final expiring = result.where((p) => p.expires != null).toList();
      setState(() {
        allProducts = expiring;
        filteredProducts = expiring;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void applyFilters() {
    setState(() {
      filteredProducts =
          allProducts.where((product) {
            final nameMatch = product.name.toLowerCase().contains(
              search.toLowerCase(),
            );
            final expiryDate = DateTime.tryParse(product.expires ?? '');
            final dateMatch =
                expiryDate != null &&
                (startDate == null ||
                    expiryDate.isAfter(
                      startDate!.subtract(const Duration(days: 1)),
                    )) &&
                (endDate == null ||
                    expiryDate.isBefore(endDate!.add(const Duration(days: 1))));
            return nameMatch && dateMatch;
          }).toList();
    });
  }

  void resetFilters() {
    setState(() {
      search = '';
      searchController.clear();
      startDate = null;
      endDate = null;
      filteredProducts = allProducts;
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
      appBar: AppBar(title: const Text("Product Expiry Report")),
      body:
          _loading
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Text(
                        "Filtered: ${DateFormat('yyyy-MM-dd').format(startDate!)} to ${DateFormat('yyyy-MM-dd').format(endDate!)}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  const SizedBox(height: 5),
                  Expanded(
                    child:
                        filteredProducts.isEmpty
                            ? const Center(child: Text("No matching products"))
                            : ListView.builder(
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                final imageUrl =
                                    product.image != null &&
                                            product.image != "null"
                                        ? "https://apibrize.brizindia.com/storage/${product.image}"
                                        : null;

                                return Card(
                                  margin: const EdgeInsets.all(8),
                                  child: ListTile(
                                    leading:
                                        imageUrl != null
                                            ? Image.network(
                                              imageUrl,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return const Icon(
                                                  Icons.image_not_supported,
                                                  size: 40,
                                                );
                                              },
                                            )
                                            : const Icon(
                                              Icons.image_not_supported,
                                              size: 40,
                                            ),
                                    title: Text(product.name),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Price: ₹${product.rate}"),
                                        Text(
                                          "Stock: ${product.currentStock} pcs",
                                        ),
                                        Text(
                                          "Expiry: ${product.expires ?? 'N/A'}",
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
    );
  }
}
