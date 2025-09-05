import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/jwellery/Jewellery_View/reports/StockReport.dart';
import 'package:flutter_application_1/views/jwellery/Jewellery_View/reports/daily_cash_report_screen.dart';
import 'package:flutter_application_1/views/jwellery/Jewellery_View/reports/product_report.dart'
    show ProductReportScreen;

// === Import your created report screens ===
import '../../../../services/jwelCategoryReport.dart';
import 'CategoryReport.dart';
import 'PartialOrderScreen.dart';
import 'SalesReportScreen.dart';
import 'billi-order.dart';
import 'customer_report_screen.dart';
import 'gstReport.dart';

class ReportsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reports = [
    {"title": "Product Report", "icon": Icons.shopping_bag},
    {"title": "Bill Report", "icon": Icons.receipt_long},
    {"title": "Daily Cash", "icon": Icons.attach_money},
    {"title": "Sale Report", "icon": Icons.point_of_sale},
    {"title": "Category Report", "icon": Icons.category},
    {"title": "Partial Reports", "icon": Icons.pie_chart},
    {"title": "Order Report", "icon": Icons.shopping_cart},
    {"title": "Stock Report", "icon": Icons.inventory},
    {"title": "GST Report", "icon": Icons.account_balance},
    {"title": "Customer Report", "icon": Icons.person_search},
  ];

  ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📊 Reports"), centerTitle: true),
      body: ListView.separated(
        itemCount: reports.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              reports[index]["icon"],
              color: Colors.deepPurple,
            ),
            title: Text(
              reports[index]["title"],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      getReportScreen(reports[index]["title"]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // === Handle navigation for each report ===
  Widget getReportScreen(String title) {
    switch (title) {
      case "Product Report":
        return const ProductReportScreen();
      case "Bill Report":
        return BillingReportScreen(title: title);
      case "Daily Cash":
        return DailyCashReportScreen(title: title);
      case "GST Report":
        return GstReportScreen(title: title);
      case "Customer Report":
        return CustomerReportScreen(title: title);
      case "Stock Report":
        return StockReportScreen(title: title);
      case "Sale Report":
        return SalesReportScreen(title: title);
      case "Partial Reports":
        return PartialOrderScreen(title: title);
      case "Category Report":
        return CategoryReportScreen(title: title);
      default:
        return ReportDetailScreen(title: title);
    }
  }
}

// === Placeholder for unimplemented reports ===
class ReportDetailScreen extends StatelessWidget {
  final String title;
  const ReportDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("$title screen coming soon...")),
    );
  }
}
