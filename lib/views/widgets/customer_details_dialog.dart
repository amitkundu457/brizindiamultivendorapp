import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../ProductSelectionScreen.dart';
import '../../controllers/CustomerController.dart';

class CustomerDetailsDialog extends StatefulWidget {
  final VoidCallback onNext;
  final List<Map<String, dynamic>> selectedProducts;
  final DateTime? selectedDate;

  const CustomerDetailsDialog({
    super.key,
    required this.onNext,
    required this.selectedProducts,
    required this.selectedDate,
  });

  @override
  State<CustomerDetailsDialog> createState() => _CustomerDetailsDialogState();
}

class _CustomerDetailsDialogState extends State<CustomerDetailsDialog> {
  List<dynamic> memberships = [];
  Map<String, dynamic>? selectedMembership;
  bool isMember = true;
  // bool hasPackage = true; // 🚫 Disabled for now, can re-enable if needed

  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final gstinController = TextEditingController();
  final additional1Controller = TextEditingController();
  final additional2Controller = TextEditingController();

  Map<String, dynamic>? existingCustomer;

  Future<void> _loadMemberships(int customerId) async {
    try {
      final data = await CustomerController.fetchMemberships(customerId);
      setState(() {
        memberships = data;
        if (memberships.isNotEmpty) {
          selectedMembership = memberships[0];
        } else {
          selectedMembership = null;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Membership not found")));
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load memberships")),
      );
    }
  }

  void _searchCustomer() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) return;

    final customer = await CustomerController.searchCustomer(phone);
    if (customer != null) {
      setState(() {
        existingCustomer = {
          'id': customer.id,
          'name': customer.name,
          'phone': customer.phone,
          'address': customer.address,
        };
        firstNameController.text = customer.name?.split(" ").first ?? '';
        lastNameController.text =
            customer.name?.split(" ").skip(1).join(" ") ?? '';
        addressController.text = customer.address ?? '';
        isMember = true;
      });

      await _loadMemberships(customer.id!);
    } else {
      setState(() {
        existingCustomer = null;
        memberships = [];
        selectedMembership = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Customer not found")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.person, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  "Customer Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// 🔍 Phone input and search
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              onFieldSubmitted: (_) => _searchCustomer(),
              decoration: InputDecoration(
                hintText: "Enter phone number & press enter",
                prefixIcon: const Icon(Icons.phone),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchCustomer,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// 🧑 Name fields
            Row(
              children: [
                Expanded(
                  child: _styledInput(
                    "First Name",
                    controller: firstNameController,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _styledInput(
                    "Last Name",
                    controller: lastNameController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            /// 🏠 Address and info
            _styledInput("Address", controller: addressController, maxLines: 2),
            const SizedBox(height: 14),
            _styledInput("GSTIN", controller: gstinController),
            const SizedBox(height: 14),
            _styledInput(
              "Additional Field 1",
              controller: additional1Controller,
            ),
            const SizedBox(height: 14),
            _styledInput(
              "Additional Field 2",
              controller: additional2Controller,
            ),
            const SizedBox(height: 16),

            /// ✅ Membership checkbox
            Row(
              children: [
                _buildCheckbox("Membership", isMember, (v) {
                  setState(() {
                    isMember = v ?? false;
                    if (!isMember) selectedMembership = null;
                  });
                }),

                // _buildCheckbox("Package", hasPackage, (v) => setState(() => hasPackage = v ?? false)), // 🔲 Optional future use
              ],
            ),

            /// 🎟️ Membership dropdown
            if (isMember)
              memberships.isNotEmpty
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const Text("Select Membership Plan"),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<Map<String, dynamic>>(
                        value: selectedMembership,
                        items:
                            memberships
                                .map((m) {
                                  final plan = m['plan'];
                                  return DropdownMenuItem<Map<String, dynamic>>(
                                    value: m,
                                    child: Text(
                                      '${plan['name']} (Discount: ${plan['discount']}%)',
                                    ),
                                  );
                                })
                                .toList()
                                .cast<
                                  DropdownMenuItem<Map<String, dynamic>>
                                >(), // ✅ This fixes the type error
                        onChanged: (value) {
                          setState(() {
                            selectedMembership = value;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  )
                  : const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Membership not found",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

            const SizedBox(height: 24),

            /// ✅ Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    label: const Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _proceedToNext,
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text("Next"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToNext() {
    final customerData = {
      'id': existingCustomer?['id'],
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'gstin': gstinController.text,
      'additional1': additional1Controller.text,
      'additional2': additional2Controller.text,
      'isMember': isMember,
      // 'hasPackage': hasPackage, // 🔲 Optional field if needed
      'discount':
          isMember ? (selectedMembership?['plan']?['discount'] ?? '0') : '0',
      'dateid': widget.selectedDate?.toIso8601String().substring(0, 10),
    };

    final productList =
        widget.selectedProducts.map((e) => e['product'] as Product).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ProductSelectionScreen(
              customer: customerData,
              selectedProducts: productList,
            ),
      ),
    );
  }

  Widget _styledInput(
    String hint, {
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }

  Widget _buildCheckbox(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.deepPurple,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _button(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
