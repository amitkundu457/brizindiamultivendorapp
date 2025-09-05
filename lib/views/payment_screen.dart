import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/product_model.dart';
import 'invoice_pdf.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> customer;
  final List<Product> products;
  final double grossTotal;
  final double taxTotal;
  final double netTotal;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.customer,
    required this.products,
    required this.grossTotal,
    required this.taxTotal,
    required this.netTotal,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double cash = 0;
  double card = 0;
  double upi = 0;

  final TextEditingController upiController = TextEditingController();
  final TextEditingController cashController = TextEditingController();
  final TextEditingController cardController = TextEditingController();

  double get discountPercentage {
    final discount = widget.customer['discount'];
    return double.tryParse(discount?.toString() ?? '0') ?? 0;
  }

  double get discountAmount => widget.grossTotal * discountPercentage / 100;
  double get payableAmount => widget.totalAmount - discountAmount;
  double get totalPaid => cash + card + upi;
  double get remaining => payableAmount - totalPaid;

  void checkout() async {
    if (remaining != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete full payment.")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authorization token not found.")),
      );
      return;
    }

    final productsJson =
        widget.products.map((p) {
          double rate = double.tryParse(p.rate ?? '0') ?? 0;
          double qty = (p.qty ?? 1).toDouble();
          double proTotal = rate * qty;
          double tax = rate * (p.taxRate ?? 0) / 100;

          return {
            "name": p.name,
            "tax_rate": p.taxRate ?? 0,
            "product_id": p.id,
            "qty": qty,
            "rate": rate.toStringAsFixed(2),
            "pro_total": proTotal.toStringAsFixed(2),
            "salesman_id": null,
            "stylist_id": 1,
            "totalDiscount": 0,
            "tax_total": tax.toStringAsFixed(2),
          };
        }).toList();

    final payload = {
      "bill_inv": 1,
      "customer_id": widget.customer['id'],
      "dateid":
          widget.customer['dateid'] ??
          DateTime.now().toIso8601String().substring(0, 10),
      "discountTotal": discountAmount.toStringAsFixed(2),
      "grossTotal": widget.totalAmount.toStringAsFixed(2),
      "membDiscount": "${discountPercentage.toStringAsFixed(2)}%",
      "paymentMethods": [
        {"payment_method": "cash", "price": cash},
        {"payment_method": "card", "price": card},
        {"payment_method": "upi", "price": upi},
      ],
      "printStatus_id": "",
      "products": productsJson,
    };

    final response = await http.post(
      Uri.parse("https://apibrize.brizindia.com/api/saloon-order"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final createdOrder = jsonDecode(response.body);
      final orderId =
          createdOrder['order_id'] ?? createdOrder['data']?['order_id'];
      print("Order ID: $orderId");

      // Fetch full invoice data
      final invoiceResponse = await http.get(
        Uri.parse(
          "https://apibrize.brizindia.com/api/saloon-printbill/$orderId",
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      if (invoiceResponse.statusCode == 200) {
        final invoiceData = jsonDecode(invoiceResponse.body);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order placed successfully!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => InvoicePreview(orderData: invoiceData),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to fetch invoice: ${invoiceResponse.body}"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order creation failed: ${response.body}")),
      );
    }
  }

  Widget _buildPaymentInput(
    String label,
    TextEditingController controller,
    Function(String) onChanged,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: "$label Amount"),
      onChanged: (val) => onChanged(val),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Breakdown")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gross Total: ₹${widget.grossTotal.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),
            if (discountPercentage > 0)
              Text(
                "Membership Discount (${discountPercentage.toStringAsFixed(2)}%): -₹${discountAmount.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.green),
              ),

            Text(
              "Total Tax: ₹${widget.taxTotal.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Net Payable: ₹${payableAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text("Enter Payment Amounts", style: TextStyle(fontSize: 16)),
            _buildPaymentInput("Cash", cashController, (val) {
              setState(() => cash = double.tryParse(val) ?? 0);
            }),
            _buildPaymentInput("Card", cardController, (val) {
              setState(() => card = double.tryParse(val) ?? 0);
            }),
            _buildPaymentInput("UPI", upiController, (val) {
              setState(() => upi = double.tryParse(val) ?? 0);
            }),
            const SizedBox(height: 10),
            Text(
              remaining > 0
                  ? "Remaining: ₹${remaining.toStringAsFixed(2)}"
                  : remaining < 0
                  ? "Overpaid: ₹${(-remaining).toStringAsFixed(2)}"
                  : "Payment Complete!",
              style: TextStyle(
                color: remaining == 0 ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text("Back"),
                ),
                ElevatedButton(
                  onPressed: checkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Checkout"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
