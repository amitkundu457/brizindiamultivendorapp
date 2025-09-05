import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/packageinput.dart';
import 'package:http/http.dart' as http;

class PackageSearchPage extends StatefulWidget {
  const PackageSearchPage({super.key});

  @override
  State<PackageSearchPage> createState() => _PackageSearchPageState();
}

class _PackageSearchPageState extends State<PackageSearchPage> {
  final TextEditingController _phoneController = TextEditingController();

  Map<String, dynamic>? _customer;
  List<Map<String, dynamic>> _packages = [];

  bool _searched = false;
  bool _enabled = false;
  bool _isLoading = false;

  Future<void> _searchCustomer() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    setState(() {
      _searched = false;
      _customer = null;
      _packages = [];
      _enabled = false;
      _isLoading = true;
    });

    try {
      final url =
          "https://apibrize.brizindia.com/api/customers/search?phone=$phone";
      final res = await http.get(Uri.parse(url));
      debugPrint("📞 URL: $url");
      debugPrint("📦 Response: ${res.body}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        if (data.isNotEmpty) {
          setState(() {
            _customer = data;
            _searched = true;
          });
        } else {
          setState(() => _searched = true);
        }
      } else {
        debugPrint("❌ HTTP error: ${res.statusCode}");
        setState(() => _searched = true);
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
      setState(() => _searched = true);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _fetchPackages() async {
    final userId = _customer?['id'];
    if (userId == null) return;

    final url =
        "https://apibrize.brizindia.com/api/packagesassign/$userId?enabled=true";

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final List packages = data['data'] ?? [];
        setState(() {
          _packages = List<Map<String, dynamic>>.from(packages);
        });
      } else {
        debugPrint("❌ Package fetch failed: ${res.body}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching packages: $e");
    }
  }

  void _bookNow() {
    final int? customerId = _customer?['id'];
    if (customerId == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PackageBillingForm(customerId: customerId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Customer Package"),
        centerTitle: true,
        backgroundColor: const Color(0xFF16A34A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter phone number",
                prefixIcon: const Icon(Icons.phone),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _phoneController.clear();
                    setState(() {
                      _customer = null;
                      _packages.clear();
                      _searched = false;
                      _enabled = false;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (_) => _searchCustomer(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchCustomer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
              ),
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Text("Search"),
            ),
            const SizedBox(height: 20),

            if (_searched && _customer != null) ...[
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(_customer!['name'] ?? ''),
                  subtitle: Text("${_customer!['phone']}"),
                ),
              ),
              CheckboxListTile(
                title: const Text("Enable to fetch package"),
                value: _enabled,
                onChanged: (val) {
                  setState(() => _enabled = val ?? false);
                  if (val == true) _fetchPackages();
                },
              ),
              const SizedBox(height: 8),

              _packages.isNotEmpty
                  ? Expanded(
                    child: ListView.builder(
                      itemCount: _packages.length,
                      itemBuilder: (context, index) {
                        final package = _packages[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "📦 Package Name: ${package['package_name']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text("📄 Package No: ${package['package_no']}"),
                                Text("🧾 Receipt No: ${package['receipt_no']}"),
                                Text(
                                  "💰 Package Amount: ₹${package['package_amount']}",
                                ),
                                Text(
                                  "💵 Service Amount: ₹${package['service_amount']}",
                                ),
                                Text(
                                  "✅ Paid Amount: ₹${package['paid_amount']}",
                                ),
                                Text(
                                  "💳 Remaining Amount: ₹${package['remaining_amount']}",
                                ),
                                Text(
                                  "🧮 Balance Amount: ₹${package['balance_amount']}",
                                ),
                                Text(
                                  "🧾 Receipt Amount: ₹${package['receipt_amount']}",
                                ),
                                Text(
                                  "📅 Payment Date: ${package['payment_date']}",
                                ),
                                Text(
                                  "📆 Booking Date: ${package['package_booking']}",
                                ),
                                Text(
                                  "⏳ Expiry Date: ${package['package_expiry']}",
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  : _enabled
                  ? Column(
                    children: [
                      const Text(
                        "No package found.",
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _bookNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("Book Now"),
                      ),
                    ],
                  )
                  : const SizedBox(),
            ] else if (_searched && _customer == null) ...[
              const Text(
                "Customer not found",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
