import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'payment_screen.dart';

class ProductSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> customer;
  final List<Product> selectedProducts;

  const ProductSelectionScreen({
    super.key,
    required this.customer,
    required this.selectedProducts,
  });

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  late List<Product> selectedProducts;

  @override
  void initState() {
    super.initState();
    selectedProducts = List<Product>.from(widget.selectedProducts);
  }

  double get grossTotal =>
      selectedProducts.fold(0, (sum, p) => sum + double.parse(p.rate ?? '0'));

  double get totalTax => selectedProducts.fold(
    0,
    (sum, p) => sum + (double.parse(p.rate ?? '0') * (p.taxRate ?? 0) / 100),
  );

  double get discountPercent {
    final raw = widget.customer['discount'];
    if (raw == null) return 0;
    return double.tryParse(raw.toString()) ?? 0;
  }

  double get discount => grossTotal * (discountPercent / 100);
  double get netTotal => (grossTotal - discount) + totalTax;

  void removeProduct(Product product) {
    setState(() {
      selectedProducts.remove(product);
    });
  }

  void submitOrder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => PaymentScreen(
              customer: widget.customer,
              products: selectedProducts,
              grossTotal: grossTotal,
              taxTotal: totalTax,
              netTotal: netTotal ,
              totalAmount: grossTotal + totalTax,
            ),
      ),
    );

    if (result == true) {
      setState(() {
        selectedProducts.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Welcome ${widget.customer['firstName']}'),
          ),
          Expanded(
            child:
                selectedProducts.isEmpty
                    ? const Center(child: Text("No products selected"))
                    : ListView.builder(
                      itemCount: selectedProducts.length,
                      itemBuilder: (context, index) {
                        final product = selectedProducts[index];
                        return ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          title: Text(product.name),
                          subtitle: Text(
                            "Rate: ₹${product.rate} | Tax: ${product.taxRate}%",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeProduct(product),
                          ),
                        );
                      },
                    ),
          ),
          const Divider(thickness: 1.2),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _summaryRow("Gross Total", "₹${grossTotal.toStringAsFixed(2)}"),
                _summaryRow(
                  "Discount (${discountPercent.toStringAsFixed(0)}%)",
                  "₹${discount.toStringAsFixed(2)}",
                ),
                _summaryRow("Total Tax", "₹${totalTax.toStringAsFixed(2)}"),
                const Divider(),
                _summaryRow(
                  "Net Total",
                  "₹${netTotal.toStringAsFixed(2)}",
                  bold: true,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Place Order",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
