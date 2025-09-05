import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../controllers/Jewellery_Provider/BillingOrderProvider.dart';
import '../../../../models/Jewellery_Model/LocalDataModel.dart';
import '../JwelProduct_Page/billingPrint_Screen.dart';

class JwelPlaceOrder_Screen extends StatefulWidget {
  final List<Bill> billList;
  final int customerId;

  const JwelPlaceOrder_Screen({
    Key? key,
    required this.billList,
    required this.customerId,
  }) : super(key: key);

  @override
  _JwelPlaceOrder_ScreenState createState() => _JwelPlaceOrder_ScreenState();
}

class _JwelPlaceOrder_ScreenState extends State<JwelPlaceOrder_Screen> {
  bool isLoading = false;

  // Controllers for payment inputs
  final TextEditingController cashCtrl = TextEditingController();
  final TextEditingController cardCtrl = TextEditingController();
  final TextEditingController upiCtrl = TextEditingController();
  final TextEditingController advanceCtrl = TextEditingController();
  final TextEditingController othersCtrl = TextEditingController();
  final TextEditingController orderNoCtrl = TextEditingController();

  // API values
  double adjustAmount = 0.0;
  double advanceAmount = 0.0;

  double get totalAmount =>
      widget.billList.fold(0.0, (sum, bill) => sum + (bill.finalAmount ?? 0.0));

  // Adjusted Final Total
  double get finalPayable => totalAmount - adjustAmount - advanceAmount;

  double get paidAmount =>
      (double.tryParse(cashCtrl.text) ?? 0) +
          (double.tryParse(cardCtrl.text) ?? 0) +
          (double.tryParse(upiCtrl.text) ?? 0) +
          (double.tryParse(advanceCtrl.text) ?? 0) +
          (double.tryParse(othersCtrl.text) ?? 0);

  double get remainingAmount => finalPayable - paidAmount;

  // API Call to fetch order by billno
  Future<void> fetchOrderByBillno(String billno) async {
    try {
      final response = await http.get(Uri.parse(
          "https://apibrize.brizindia.com/api/orders/search?billno=$billno"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'].isNotEmpty) {
          final order = data['data'][0];
          setState(() {
            adjustAmount =
                double.tryParse(order['adjustAmount'].toString()) ?? 0.0;
            advanceAmount =
                double.tryParse(order['advanceAmount'].toString()) ?? 0.0;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No order found with this Order No")),
          );
        }
      }
    } catch (e) {
      print("Error fetching order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // 💰 Final Payable Amount
          _amountBox("Final Payable Amount", finalPayable, Colors.green),

          const SizedBox(height: 20),

          // Order No Search
          TextField(
            controller: orderNoCtrl,
            decoration: InputDecoration(
              labelText: "Enter Order No",
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.green),
                onPressed: () async {
                  if (orderNoCtrl.text.isNotEmpty) {
                    await fetchOrderByBillno(orderNoCtrl.text.trim());
                  }
                },
              ),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),

          // 🧾 Payment Method Inputs
          _buildPaymentInput("Cash", cashCtrl, Icons.money),
          _buildPaymentInput("Card", cardCtrl, Icons.credit_card),
          _buildPaymentInput("UPI", upiCtrl, Icons.phone_android),
          _buildPaymentInput("Advance", advanceCtrl, Icons.account_balance),
          _buildPaymentInput("Others", othersCtrl, Icons.more_horiz),

          const SizedBox(height: 20),

          // ⚖️ Remaining Amount
          Text(
            remainingAmount > 0
                ? "Remaining Amount: ₹${remainingAmount.toStringAsFixed(2)}"
                : remainingAmount < 0
                ? "Extra Paid: ₹${(-remainingAmount).toStringAsFixed(2)}"
                : "Payment Complete 🎉",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: remainingAmount == 0 ? Colors.green : Colors.red),
          ),
          const SizedBox(height: 20),

          // 📊 Payment Breakdown
          const Text("Payment Breakdown",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildBreakdownRow("Cash", cashCtrl),
          _buildBreakdownRow("Card", cardCtrl),
          _buildBreakdownRow("UPI", upiCtrl),
          _buildBreakdownRow("Advance", advanceCtrl),
          _buildBreakdownRow("Others", othersCtrl),

          const SizedBox(height: 30),

          // 🧾 Final Summary Box
          _summaryBox(),

          const SizedBox(height: 15),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Back",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: remainingAmount > 0
                      ? null
                      : () async {
                    setState(() => isLoading = true);

                    final paymentData = {
                      "cash": double.tryParse(cashCtrl.text) ?? 0,
                      "card": double.tryParse(cardCtrl.text) ?? 0,
                      "upi": double.tryParse(upiCtrl.text) ?? 0,
                      "advance": double.tryParse(advanceCtrl.text) ?? 0,
                      "others": double.tryParse(othersCtrl.text) ?? 0,
                    };

                    print("👉 Payment Data: $paymentData");

                    // TODO: save order in provider or API
                    // await context.read<BillingOrderProvider>().saveOrder(
                    //   customerId: widget.customerId,
                    //   billList: widget.billList,
                    //   payments: paymentData,
                    // );

                    setState(() => isLoading = false);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BillingPrint_Screen()),
                    );
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Checkout",
                      style:
                      TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  // 🔹 Widgets
  Widget _buildPaymentInput(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "$label Amount",
          prefixIcon: Icon(icon, color: Colors.green),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, TextEditingController controller) {
    final value = double.tryParse(controller.text) ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text("₹${value.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }

  Widget _summaryBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow("Total Amount", totalAmount),
          _buildSummaryRow("Advance Amount", advanceAmount),
          _buildSummaryRow("Adjust Amount", adjustAmount,
              color: Colors.orange),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Final Payable:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("₹${finalPayable.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text("₹${value.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color ?? Colors.black,
              )),
        ],
      ),
    );
  }

  Widget _amountBox(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("₹${value.toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
