import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/stylist_model.dart';
import '../services/product_service.dart';
import 'widgets/product_tile.dart';
import '../views/widgets/customer_details_dialog.dart';
import 'widgets/product_tile_skeleton.dart';

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  String billNo = '';
  List<Category> categories = [];
  String? selectedCategory;
  List<Stylist> stylists = [];
  String? selectedStylist;
  String? selectedFormat;
  String? selectedProSerType = 'Product';

  DateTime? selectedDate;
  bool showProducts = false;
  bool isLoading = true;
  String error = '';
  String searchText = '';

  List<Product> allProducts = [];
  List<Map<String, dynamic>> cartItems = [];

  Future<void> fetchCategories() async {
    try {
      categories = await ProductService.fetchCategories();
      if (categories.isNotEmpty && selectedCategory == null) {
        selectedCategory = categories.first.name;
      }
      setState(() {});
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> fetchStylists() async {
    try {
      stylists = await ProductService.fetchStylists();
      if (stylists.isNotEmpty && selectedStylist == null) {
        selectedStylist = stylists.first.name;
      }
      setState(() {});
    } catch (e) {
      print("Error fetching stylists: $e");
    }
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    try {
      final products = await ProductService.fetchProducts(
        type: selectedProSerType,
        category: selectedCategory,
        search: "",
      );
      setState(() {
        allProducts = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void getBillNo() async {
    final fetched = await ProductService.fetchBillNo();
    setState(() {
      billNo = fetched;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchStylists();
    fetchCategories();
    fetchProducts();
    getBillNo();
  }

  void _handleAddToCart(Product product, int qty) {
    final index = cartItems.indexWhere(
      (item) => item['product'].id == product.id,
    );
    if (index != -1) {
      cartItems[index]['quantity'] = qty;
    } else {
      cartItems.add({'product': product, 'quantity': qty});
    }
    setState(() {});
  }

  double _calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      final rate =
          double.tryParse(item['product'].rate?.toString() ?? "0") ?? 0.0;
      final quantity = item['quantity'] ?? 1;
      total += rate * quantity;
    }
    return total;
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Filter Options",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                "Select Type",
                selectedProSerType,
                (val) => setState(() => selectedProSerType = val),
                items: const [
                  DropdownMenuItem(value: "Product", child: Text("Product")),
                  DropdownMenuItem(value: "Service", child: Text("Service")),
                ],
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                "Select Category",
                selectedCategory,
                (val) => setState(() => selectedCategory = val),
                items:
                    categories
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat.name,
                            child: Text(cat.name),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  fetchProducts();
                },
                child: const Text("Apply Filters"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    Function(String?) onChanged, {
    List<DropdownMenuItem<String>>? items,
  }) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(),
      ),
      value: value,
      hint: Text(label),
      onChanged: onChanged,
      items: items ?? const [],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text:
            selectedDate != null
                ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                : '',
      ),
      decoration: InputDecoration(
        hintText: "Select Date",
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2024),
              lastDate: DateTime(2030),
            );
            if (pickedDate != null) {
              setState(() {
                selectedDate = pickedDate;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 600;
    final filteredProducts =
        searchText.isEmpty
            ? allProducts
            : allProducts
                .where(
                  (product) => product.name.toLowerCase().contains(
                    searchText.toLowerCase(),
                  ),
                )
                .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF16A34A),
        title: const Text(
          "Product/Service Billing",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!showProducts) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: Text(
                  billNo.isEmpty ? "Generating Bill No..." : billNo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel("Billing Date"),
              const SizedBox(height: 6),
              _buildDatePicker(context),
              const SizedBox(height: 16),
              _buildLabel("Stylist"),
              const SizedBox(height: 6),
              _buildDropdown(
                "Select Stylist",
                selectedStylist,
                (val) => setState(() => selectedStylist = val),
                items:
                    stylists
                        .map(
                          (s) => DropdownMenuItem(
                            value: s.name,
                            child: Text(s.name),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 16),
              _buildLabel("Billing Format"),
              const SizedBox(height: 6),
              _buildDropdown(
                "Select Billing Format",
                selectedFormat,
                (val) => setState(() => selectedFormat = val),
              ),
              const SizedBox(height: 80),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Search Item',
                      ),
                      onChanged: (val) => setState(() => searchText = val),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.filter_alt_outlined),
                    onPressed: _openFilterSheet,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (error.isNotEmpty)
                Center(child: Text(error))
              else
                GridView.count(
                  crossAxisCount: isSmallScreen ? 1 : 4,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 2,
                  childAspectRatio: 3.5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children:
                      filteredProducts.map((product) {
                        final existing = cartItems.firstWhere(
                          (e) => e['product'].id == product.id,
                          orElse: () => {},
                        );
                        final selectedQty =
                            existing.isNotEmpty ? existing['quantity'] ?? 0 : 0;
                        return ProductTile(
                          product: product,
                          selectedQuantity: selectedQty,
                          onAddToCart: _handleAddToCart,
                        );
                      }).toList(),
                ),
              const SizedBox(height: 80),
            ],
          ],
        ),
      ),
      bottomNavigationBar:
          !showProducts
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF16A34A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => setState(() => showProducts = true),
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
              : cartItems.isNotEmpty
              ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ₹${_calculateTotal().toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => CustomerDetailsDialog(
                                onNext:
                                    () => print("Customer Details Completed"),
                                selectedDate: selectedDate,
                                selectedProducts: cartItems,
                              ),
                        );
                      },
                      child: const Text("Checkout"),
                    ),
                  ],
                ),
              )
              : null,
    );
  }
}
