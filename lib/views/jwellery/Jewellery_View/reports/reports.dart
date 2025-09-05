import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/jwellery/Jewellery_View/reports/daily_cash_report_screen.dart';
import 'package:flutter_application_1/views/jwellery/Jewellery_View/reports/product_report.dart' show ProductReportScreen;

// === Import your created report screens ===


import 'billi-order.dart';

// === ReportsScreen ===
class ReportsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reports = [
    {"title": "Product Report", "icon": Icons.shopping_bag},
    {"title": "Services Report", "icon": Icons.miscellaneous_services},
    {"title": "Bill Report", "icon": Icons.receipt_long},
    {"title": "Daily Cash", "icon": Icons.attach_money},
    {"title": "Assign Package Reports", "icon": Icons.assignment},
    {"title": "Sale Report", "icon": Icons.point_of_sale},
    {"title": "Category Report", "icon": Icons.category},
    {"title": "Partial Reports", "icon": Icons.pie_chart},
    {"title": "Party Report", "icon": Icons.people},
    {"title": "Order Report", "icon": Icons.shopping_cart},
    {"title": "Sales Register", "icon": Icons.library_books},
    {"title": "Agent Sale", "icon": Icons.person},
    {"title": "Stock Report", "icon": Icons.inventory},
    {"title": "GST Report", "icon": Icons.account_balance},
    {"title": "Customer Report", "icon": Icons.person_search},
  ];

  ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(reports[index]["icon"]),
            title: Text(reports[index]["title"]),
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
        return DailyCashReportScreen(title: title); // 🔹 create this screen
      default:
        return ReportDetailScreen(title: title); // fallback
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
