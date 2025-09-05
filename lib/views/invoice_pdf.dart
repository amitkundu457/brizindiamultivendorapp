import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/dashboard/main_dashboard_loader.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'dashboard/saloon_dashboard.dart';

class InvoicePreview extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const InvoicePreview({super.key, required this.orderData});

  String _formatCurrency(dynamic amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatter.format(double.tryParse(amount.toString()) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final customer = orderData['users']?['name'] ?? 'N/A';
    final phone = orderData['users']?['customers']?[0]?['phone'] ?? 'N/A';
    final invoiceNo = orderData['billno'] ?? 'N/A';
    final invoiceDate = orderData['date'] ?? 'N/A';
    final totalBalance = orderData['total_price'] ?? '0.00';
    final payments = orderData['saloon_payments'] ?? [];
    final productList = orderData['saloon_details'] ?? [];

    String paymentMethod =
        payments.isNotEmpty
            ? payments.map((p) => p['payment_method']).join(', ')
            : 'N/A';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove back button
        title: const Text("Invoice"),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _printInvoice(context),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Customer Name:", customer),
                    _infoRow("Mobile No:", phone),
                    _infoRow("Invoice No:", invoiceNo),
                    _infoRow("Invoice Date:", invoiceDate),
                    _infoRow("Total Balance:", _formatCurrency(totalBalance)),
                    _infoRow("Payment Mode:", paymentMethod),
                    const SizedBox(height: 12),

                    // Product Table
                    Table(
                      border: TableBorder.all(color: Colors.grey.shade400),
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(2),
                      },
                      children: [
                        _tableRow([
                          "Service & Product",
                          "Amount",
                          "Qty",
                          "Total",
                        ], isHeader: true),
                        ...productList.map<TableRow>((item) {
                          return _tableRow([
                            item['product_name'] ?? '',
                            item['rate'] ?? '0',
                            item['qty'] ?? '0',
                            item['pro_total'] ?? '0',
                          ]);
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),

                    // Totals
                    _amountRow(
                      "Total Amount (Before Discount)",
                      _formatCurrency(orderData['gross_total']),
                      bold: true,
                    ),
                    _amountRow(
                      "Membership Discount",
                      "-${_formatCurrency(orderData['discount'] ?? '0')}",
                      red: true,
                    ),
                    const Divider(),
                    _amountRow(
                      "Net Amount",
                      _formatCurrency(totalBalance),
                      bold: true,
                    ),

                    const SizedBox(height: 24),

                    // Tax Breakdown
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Table(
                        border: TableBorder.all(color: Colors.grey.shade300),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(2),
                        },
                        children: [
                          _tableRow([
                            "HSN/SAC",
                            "Taxable",
                            "CGST",
                            "SGST",
                            "Total Tax",
                          ], isHeader: true),
                          ...productList.map<TableRow>((item) {
                            final rate =
                                double.tryParse(item['rate'] ?? '0') ?? 0;
                            final taxRate =
                                double.tryParse(item['tax_rate'] ?? '0') ?? 0;
                            final tax = rate * taxRate / 100;
                            final halfTax = (tax / 2).toStringAsFixed(2);
                            return _tableRow([
                              "-",
                              rate.toStringAsFixed(2),
                              halfTax,
                              halfTax,
                              tax.toStringAsFixed(2),
                            ]);
                          }).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        "****THANK YOU. PLEASE VISIT AGAIN****",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text("Go to Home"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => MainDashboardLoader()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _tableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey.shade200 : Colors.transparent,
      ),
      children:
          cells.map((cell) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cell,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _amountRow(
    String label,
    String amount, {
    bool bold = false,
    bool red = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: red ? Colors.red : Colors.black,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: red ? Colors.red : Colors.black,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printInvoice(BuildContext context) async {
    final customer = orderData['users']?['name'] ?? 'N/A';
    final phone = orderData['users']?['customers']?[0]?['phone'] ?? 'N/A';
    final invoiceNo = orderData['billno'] ?? 'N/A';
    final invoiceDate = orderData['date'] ?? 'N/A';
    final totalBalance = orderData['total_price'] ?? '0.00';
    final payments = orderData['saloon_payments'] ?? [];
    final productList = orderData['saloon_details'] ?? [];

    String paymentMethod =
        payments.isNotEmpty
            ? payments.map((p) => p['payment_method']).join(', ')
            : 'N/A';

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'INVOICE',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text("Customer Name: $customer"),
              pw.Text("Mobile No: $phone"),
              pw.Text("Invoice No: $invoiceNo"),
              pw.Text("Invoice Date: $invoiceDate"),
              pw.Text("Total Balance: ₹$totalBalance"),
              pw.Text("Payment Mode: $paymentMethod"),
              pw.SizedBox(height: 12),

              pw.Text('Products', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 6),
              pw.Table.fromTextArray(
                headers: ['Service & Product', 'Amount', 'Qty', 'Total'],
                data:
                    productList.map<List<String>>((item) {
                      return [
                        item['product_name']?.toString() ?? '',
                        item['rate']?.toString() ?? '0',
                        item['qty']?.toString() ?? '0',
                        item['pro_total']?.toString() ?? '0',
                      ];
                    }).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellStyle: const pw.TextStyle(fontSize: 10),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              ),

              pw.SizedBox(height: 12),
              pw.Text(
                "Total Amount (Before Discount): ₹${orderData['gross_total']}",
              ),
              pw.Text(
                "Membership Discount: -₹${orderData['discount'] ?? '0.00'}",
                style: pw.TextStyle(color: PdfColors.red),
              ),
              pw.Text(
                "Net Amount: ₹${orderData['total_price']}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),

              pw.SizedBox(height: 20),
              pw.Text('Tax Breakdown', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 6),
              pw.Table.fromTextArray(
                headers: ['HSN/SAC', 'Taxable', 'CGST', 'SGST', 'Total Tax'],
                data:
                    productList.map<List<String>>((item) {
                      final rate =
                          double.tryParse(item['rate']?.toString() ?? '0') ?? 0;
                      final taxRate =
                          double.tryParse(
                            item['tax_rate']?.toString() ?? '0',
                          ) ??
                          0;
                      final tax = rate * taxRate / 100;
                      final halfTax = (tax / 2).toStringAsFixed(2);
                      return [
                        "-",
                        rate.toStringAsFixed(2),
                        halfTax,
                        halfTax,
                        tax.toStringAsFixed(2),
                      ];
                    }).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellStyle: const pw.TextStyle(fontSize: 10),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              ),

              pw.SizedBox(height: 24),
              pw.Center(
                child: pw.Text(
                  "****THANK YOU. PLEASE VISIT AGAIN****",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
