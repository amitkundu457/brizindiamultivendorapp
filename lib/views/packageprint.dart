import 'package:flutter/material.dart';

class PrintInvoiceScreen extends StatelessWidget {
  final Map<String, dynamic> customer;
  final List<Map<String, dynamic>> services;
  final Map<String, dynamic> package;
  final Map<String, dynamic> userInfo;

  const PrintInvoiceScreen({
    super.key,
    required this.customer,
    required this.services,
    required this.package,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                userInfo['business_name'] ?? 'Salon Name',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "Ph: ${userInfo['mobile_number'] ?? '-'}",
                textAlign: TextAlign.center,
              ),
              Text(
                "Email: ${userInfo['email'] ?? '-'}",
                textAlign: TextAlign.center,
              ),
              if ((userInfo['gst'] ?? '').toString().isNotEmpty)
                Text(
                  "GST No: ${userInfo['gst']}",
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              const Divider(),
              _buildCustomerDetails(),
              const SizedBox(height: 16),
              _buildServiceTable(),
              const SizedBox(height: 16),
              _buildPackageDetails(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Optionally integrate with a print plugin
                },
                child: const Text("Print"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerDetails() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Customer Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text("Name: ${customer['name']}"),
          Text("Phone: ${customer['phone']}"),
          Text("Email: ${customer['email'] ?? '-'}"),
        ],
      ),
    );
  }

  Widget _buildServiceTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Services", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.black26),
          columnWidths: const {
            0: FixedColumnWidth(30),
            1: FixedColumnWidth(60),
            2: FlexColumnWidth(),
            3: FixedColumnWidth(80),
            4: FixedColumnWidth(70),
          },
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
              children: [
                Padding(padding: EdgeInsets.all(6), child: Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(padding: EdgeInsets.all(6), child: Text("Pkg ID", style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(padding: EdgeInsets.all(6), child: Text("Service Name", style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(padding: EdgeInsets.all(6), child: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(padding: EdgeInsets.all(6), child: Text("Type", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            ...services.map((service) {
              return TableRow(children: [
                Padding(padding: const EdgeInsets.all(6), child: Text("${service['id']}")),
                Padding(padding: const EdgeInsets.all(6), child: Text("${service['package_id']}")),
                Padding(padding: const EdgeInsets.all(6), child: Text("${service['service_name']}")),
                Padding(padding: const EdgeInsets.all(6), child: Text("${service['total_quantity']}")),
                Padding(padding: const EdgeInsets.all(6), child: Text("${service['type']}")),
              ]);
            }).toList()
          ],
        ),
      ],
    );
  }

  Widget _buildPackageDetails() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Package Details", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Package Name: ${package['package_name']}"),
          Text("Package No: ${package['package_no']}"),
          Text("Receipt No: ${package['receipt_no']}"),
          Text("Service Amount: ₹${package['service_amount']}"),
          Text("Package Amount: ₹${package['package_amount']}"),
          Text("Paid Amount: ₹${package['paid_amount']}"),
          Text("Package Expiry: ${package['package_expiry']}"),
        ],
      ),
    );
  }
}
