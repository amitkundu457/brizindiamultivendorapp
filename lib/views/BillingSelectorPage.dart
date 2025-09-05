import 'package:flutter/material.dart';
// import 'package:your_app/pages/package_billing_page.dart';
// import 'package:your_app/pages/product_billing_page.dart';

import 'billing_page.dart';
import 'package.dart';

class BillingSelectorPage extends StatelessWidget {
  const BillingSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: const Text("Choose Billing Type"),
      //   backgroundColor: const Color(0xFF16A34A),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBillingButton(
              context,
              title: "Product/Service Billing",
              icon: Icons.receipt_long,
              color: Colors.blue,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BillingPage()),
                  ),
            ),
            const SizedBox(height: 20),
            _buildBillingButton(
              context,
              title: "Package Billing",
              icon: Icons.card_giftcard,
              color: Colors.orange,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PackageSearchPage(),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 60),
        textStyle: const TextStyle(fontSize: 18),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 28),
      label: Text(title),
    );
  }
}
