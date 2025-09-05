import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/Jewellery_Provider/BillGetProvider.dart';
import '../../../../models/Jewellery_Model/BillingModel.dart';
import '../JwelProduct_Page/ProductView_Screen.dart';
import 'JwelPlaceOrder_Screen.dart';

class JwelHome_Screen extends StatefulWidget {
  final Product? product;

  const JwelHome_Screen({Key? key, this.product}) : super(key: key);

  @override
  State<JwelHome_Screen> createState() => _JwelHome_ScreenState();
}

class _JwelHome_ScreenState extends State<JwelHome_Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Customer controllers
  final _phoneController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstinController = TextEditingController();

  int? _customerId;

  // Fetch customer by phone (API call)
  Future<void> fetchCustomerByPhone() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    final url = Uri.parse(
        "http://apibrize.brizindia.com/api/customers/search?phone=$phone");
    final request = await HttpClient().getUrl(url);
    final response = await request.close();

    if (response.statusCode == 200) {
      final data = await response.transform(const Utf8Decoder()).join();
      final json = jsonDecode(data);

      if (json != null && json['id'] != null) {
        setState(() {
          _customerId = json['id'];
          _customerNameController.text = json['name'] ?? "";
          _addressController.text = json['address'] ?? "";
          _gstinController.text = json['gstin'] ?? "";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No customer found")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching customer")),
      );
    }
  }

  // Popup for customer info
  Future<void> _showCustomerDialog(BillProvider billProvider) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Enter Customer Details"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Phone",
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => fetchCustomerByPhone(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.green),
                      onPressed: fetchCustomerByPhone,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _customerNameController,
                  decoration: const InputDecoration(
                    labelText: "Customer Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _gstinController,
                  decoration: const InputDecoration(
                    labelText: "GSTIN",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_customerNameController.text.isEmpty ||
                    _phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please enter Name & Phone first")),
                  );
                  return;
                }

                _customerId ??= DateTime.now().millisecondsSinceEpoch;

                Navigator.pop(context); // close popup

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JwelPlaceOrder_Screen(
                      billList: billProvider.billList,
                      customerId: _customerId!,
                    ),
                  ),
                );
              },
              child: const Text("Proceed"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final billProvider = Provider.of<BillProvider>(context);

    double totalBill = billProvider.billList.fold(
      0.0,
          (sum, bill) => sum + (bill.finalAmount ?? 0),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const JewProductViewScreen()),
              );
            }
          },
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 140),
            children: [
              // Bill list
              billProvider.billList.isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "No Bills Available",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: billProvider.billList.length,
                itemBuilder: (context, index) {
                  final bill = billProvider.billList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: const Icon(Icons.shopping_bag,
                            color: Colors.green),
                      ),
                      title: Text(
                        bill.jewelryName ?? "Unknown",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "Final Amount: ₹${bill.finalAmount ?? 0}",
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          // Footer
          if (billProvider.billList.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, -2))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ₹${totalBill.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showCustomerDialog(billProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Checkout"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
