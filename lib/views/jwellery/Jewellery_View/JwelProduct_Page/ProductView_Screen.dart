import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/Jewellery_Provider/JwelProductProvider.dart';
import '../HomePage/Home_Screen.dart';
import 'BillCreate_Screen.dart';
import '../HomePage/Report_Screen.dart';

class JewProductViewScreen extends StatefulWidget {
  const JewProductViewScreen({Key? key}) : super(key: key);

  @override
  State<JewProductViewScreen> createState() => _JewProductViewScreenState();
}

class _JewProductViewScreenState extends State<JewProductViewScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController billNoController = TextEditingController();

  DateTime? selectedDate;
  String? invoiceType;
  bool isApprovalOn = true;
  bool isBarcodeOn = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<JwelProductProvider>(context, listen: false).fetchProducts();
    });

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<JwelProductProvider>(context);
    final filteredProducts = productProvider.products.where((p) {
      final query = searchController.text.toLowerCase();
      return p.name.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Jewellery Invoice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => JwelHome_Screen()),
            );
          },
        ),
        actions: [
          // Bill No small text
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                billNoController.text.isEmpty
                    ? "Bill No: -"
                    : "Bill No: ${billNoController.text}",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          // Date small text
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                selectedDate == null
                    ? "Date: --/--/--"
                    : "Date: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          // Filter Icon
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _openFilterSheet(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔍 SEARCH BAR (only for products)
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Products...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🛒 Products Grid
            Expanded(
              child: productProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredProducts.isEmpty
                  ? const Center(
                child: Text(
                  "No products found",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
                  : GridView.builder(
                padding: const EdgeInsets.all(4),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BillCreate_Screen(product: product),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                              const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              child: product.image.isNotEmpty
                                  ? Image.network(
                                'https://apibrize.brizindia.com/storage/${product.image}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) =>
                                const Icon(
                                    Icons
                                        .image_not_supported,
                                    color: Colors.red,
                                    size: 60),
                              )
                                  : const Icon(
                                Icons.image_not_supported,
                                color: Colors.red,
                                size: 60,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  product.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '₹${product.rate}',
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
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

  /// 🔽 Bottom Sheet (Filter)
  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Billing Options",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Invoice Type
                  DropdownButtonFormField<String>(
                    value: invoiceType,
                    decoration:
                    const InputDecoration(labelText: "Invoice Type"),
                    items: ["INVOICE", "ESTIMATE"].map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                    onChanged: (val) {
                      setState(() => invoiceType = val);
                    },
                  ),

                  // Approval Switch
                  SwitchListTile(
                    title: const Text("Approval"),
                    value: isApprovalOn,
                    onChanged: (val) {
                      setState(() => isApprovalOn = val);
                    },
                  ),

                  // Bill No
                  TextField(
                    controller: billNoController,
                    decoration:
                    const InputDecoration(labelText: "Bill No (Enter)"),
                  ),

                  // Date Picker
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Select Date",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                          dateController.text =
                          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                        });
                      }
                    },
                  ),

                  // Barcode Switch
                  SwitchListTile(
                    title: const Text("Enable Barcode"),
                    value: isBarcodeOn,
                    onChanged: (val) {
                      setState(() => isBarcodeOn = val);
                    },
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Apply"),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
