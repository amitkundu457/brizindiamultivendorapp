import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/report/barcode_report.dart';
import 'package:flutter_application_1/views/report/bill_report.dart';
import 'package:flutter_application_1/views/report/daily_cash_report.dart';
import 'package:flutter_application_1/views/report/gst_report.dart';
import 'package:flutter_application_1/views/report/membership_report.dart';
import 'package:flutter_application_1/views/report/package_report.dart';
import 'package:flutter_application_1/views/report/product_expiry_report.dart';
import 'package:flutter_application_1/views/report/product_report.dart';
import 'package:flutter_application_1/views/report/service_report.dart';
import 'package:flutter_application_1/views/report/stock_report.dart';


class UserMenuItem {
  final String name;
  final IconData icon;
  final Widget route;

  UserMenuItem(this.name, this.icon, this.route);
}

List<UserMenuItem> get menuItems => [
  UserMenuItem("Product Report", Icons.access_time, const ProductReportScreen()),
  UserMenuItem("Services Report", Icons.access_time, const ServiceReportScreen()),
  UserMenuItem("Bill Report", Icons.access_time, const BillReportScreen()),
  UserMenuItem("Daily Cash", Icons.currency_rupee, const DailyCashReportScreen()),
  UserMenuItem("Assign Package Reports", Icons.assignment, const PackageReportScreen()),
  UserMenuItem("Stock Report", Icons.apartment, const StockReportScreen()),
  UserMenuItem("GST Report", Icons.receipt_long, const GSTReportScreen()),
  UserMenuItem("Barcode Report", Icons.qr_code, const BarcodeReportScreen()),
  UserMenuItem("Product Expiry", Icons.scale, const ProductExpiryReportScreen()),
  UserMenuItem("Membership Reports", Icons.balance, const MembershipReportScreen()),
];

class RemoteMenuScreen extends StatelessWidget {
  const RemoteMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(title: const Text("All Reports")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => item.route));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(item.icon, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
