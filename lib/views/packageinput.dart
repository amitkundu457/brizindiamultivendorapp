import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/packageprint.dart';
import 'package:intl/intl.dart';
// import '../models/BarcodePrint.dart';
import '../models/package_item.dart';
import '../services/auth_service.dart';
import '../services/package_service.dart';
import '../models/user_model.dart';
class PackageBillingForm extends StatefulWidget {
  final int customerId;

  const PackageBillingForm({super.key, required this.customerId});

  @override
  State<PackageBillingForm> createState() => _PackageBillingFormState();
}

class _PackageBillingFormState extends State<PackageBillingForm> {
  final _formKey = GlobalKey<FormState>();
  User? currentUser;
  final TextEditingController _packageAmountController = TextEditingController();
  final TextEditingController _serviceAmountController = TextEditingController();
  final TextEditingController _paidAmountController = TextEditingController();
  final TextEditingController _remainingAmountController = TextEditingController();
  final TextEditingController _paymentDateController = TextEditingController();
  final TextEditingController _bookingDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _packageNoController = TextEditingController();
  final TextEditingController _receiptNoController = TextEditingController();

  List<PackageItem> packageList = [];
  PackageItem? selectedPackageItem;

  String? selectedPaymentStatus;
  String? selectedPackageStatus;

  final List<Map<String, String>> statusOptions = [
    {"label": "Pending", "value": "0"},
    {"label": "Paid", "value": "1"},
    {"label": "Cancelled", "value": "2"},
  ];

  @override
  void initState() {
    super.initState();
    fetchPackageList();
    fetchNextPackageNumbers();
    fetchCurrentUser();
  }
  Future<void> fetchCurrentUser() async {
    try {
      final user = await AuthService.fetchUser();
      setState(() {
        currentUser = user;
      });
    } catch (e) {
      print("Failed to fetch user: $e");
    }
  }
  Future<void> fetchPackageList() async {
    packageList = await PackageService.fetchPackages();
    setState(() {});
  }

  Future<void> fetchNextPackageNumbers() async {
    final result = await PackageService.getNextPackageNumbers();
    if (result != null) {
      setState(() {
        _packageNoController.text = result.packageNo ?? '';
        _receiptNoController.text = result.receiptNo ?? '';
      });
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "packageAmount": _packageAmountController.text,
      "serviceAmount": _serviceAmountController.text,
      "paidAmount": _paidAmountController.text,
      "remainingAmount": _remainingAmountController.text,
      "paymentDate": _paymentDateController.text,
      "packageBooking": _bookingDateController.text,
      "packageExpiry": _expiryDateController.text,
      "packageNo": _packageNoController.text,
      "receiptNo": _receiptNoController.text,
      "packageStatus": selectedPackageStatus,
      "package_id": selectedPackageItem?.id,
      "paymentStatus": selectedPaymentStatus,
    };

    try {
      final result = await PackageService.submitPackageAssignment(widget.customerId, payload);
      print("🧾 Response from package assign API: $result");

      if (result != null && result['id'] != null) {
        final int assignedPackageId = result['id'];
        final invoiceData = await PackageService.fetchInvoiceData(assignedPackageId);

        if (invoiceData != null && currentUser?.information != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PrintInvoiceScreen(
                customer: {
                  'name': invoiceData['customer_info']?['name'] ?? '',
                  'phone': invoiceData['customer']?['phone'] ?? '',
                  'email': invoiceData['customer_info']?['email'] ?? '',
                },
                services: List<Map<String, dynamic>>.from(invoiceData['items'] ?? []),
                package: {
                  'package_name': invoiceData['package']?['name'] ?? '',
                  'package_no': invoiceData['assigned_package']?['package_no'] ?? '',
                  'receipt_no': invoiceData['assigned_package']?['receipt_no'] ?? '',
                  'service_amount': invoiceData['assigned_package']?['service_amount'] ?? '0',
                  'package_amount': invoiceData['assigned_package']?['package_amount'] ?? '0',
                  'paid_amount': invoiceData['assigned_package']?['paid_amount'] ?? '0',
                  'package_expiry': invoiceData['assigned_package']?['package_expiry'] ?? '',
                },
                userInfo: currentUser!.information!.toMap(),
              ),
            ),
          );
        } else {
          print("⚠️ Invoice or user info missing.");
        }
      }
    } catch (e) {
      print("❌ Error in _submitForm: $e");
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Package Billing Form"),
        backgroundColor: const Color(0xFF16A34A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Package No", _packageNoController, readOnly: true),
              _buildTextField("Receipt No", _receiptNoController, readOnly: true),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: DropdownButtonFormField<PackageItem>(
                  value: selectedPackageItem,
                  decoration: const InputDecoration(
                    labelText: "Package",
                    border: OutlineInputBorder(),
                  ),
                  items: packageList.map((pkg) {
                    return DropdownMenuItem(
                      value: pkg,
                      child: Text(pkg.name),
                    );
                  }).toList(),
                  onChanged: (pkg) {
                    setState(() {
                      selectedPackageItem = pkg;
                      _packageAmountController.text = pkg?.totalPackageAmount ?? '0';
                    });
                  },
                  validator: (val) => val == null ? 'Please select a package' : null,
                ),
              ),

              _buildTextField("Package Amount", _packageAmountController, readOnly: true),
              _buildTextField("Service Amount", _serviceAmountController),
              _buildTextField("Paid Amount", _paidAmountController),
              _buildTextField("Remaining Amount", _remainingAmountController),
              _buildDateField("Payment Date", _paymentDateController),
              _buildDateField("Package Booking", _bookingDateController),
              _buildDateField("Package Expiry", _expiryDateController),

              _buildStatusDropdown(
                label: "Payment Status",
                value: selectedPaymentStatus,
                onChanged: (val) => setState(() => selectedPaymentStatus = val),
              ),
              _buildStatusDropdown(
                label: "Package Status",
                value: selectedPackageStatus,
                onChanged: (val) => setState(() => selectedPackageStatus = val),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (!readOnly && (value == null || value.isEmpty)) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        onTap: () => _selectDate(context, controller),
        validator: (value) => value == null || value.isEmpty ? 'Date required' : null,
      ),
    );
  }

  Widget _buildStatusDropdown({
    required String label,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: statusOptions.map((option) {
          return DropdownMenuItem<String>(
            value: option['value'],
            child: Text(option['label']!),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'Required' : null,
      ),
    );
  }
}
