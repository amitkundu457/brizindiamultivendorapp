import 'package:flutter/material.dart';
import '../../../../models/Jewellery_Model/productReport.dart';
import '../../../../services/jwelproduct_report_service.dart';

class ProductReportScreen extends StatefulWidget {
  const ProductReportScreen({super.key});

  @override
  State<ProductReportScreen> createState() => _ProductReportScreenState();
}

class _ProductReportScreenState extends State<ProductReportScreen> {
  List<ProductReport> allProducts = [];
  List<ProductReport> filteredProducts = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await jwelProductReportService.fetchProducts();
      setState(() {
        allProducts = products;
        filteredProducts = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading products: $e")),
      );
    }
  }

  void _filterProducts(String query) {
    setState(() {
      searchQuery = query;
      filteredProducts = allProducts
          .where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Report"),
        backgroundColor: const Color(0xFFB8860B), // ✅ Golden color
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search by Product Name",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterProducts,
            ),
          ),
          // Product List
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text("No products found"))
                : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text(
                        "Rate: ${product.rate} | Stock: ${product.currentStock}"),
                    trailing: Text("MRP: ${product.mrp}"),
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
