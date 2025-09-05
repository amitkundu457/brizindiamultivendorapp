import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/Jewellery_Model/gstreport.dart';
import '../../../../services/gstservice.dart';

class GstReportScreen extends StatefulWidget {
  final String title;
  const GstReportScreen({super.key, required this.title});

  @override
  State<GstReportScreen> createState() => _GstReportScreenState();
}

class _GstReportScreenState extends State<GstReportScreen> {
  List<GstInvoice> gstData = [];
  bool isLoading = true;

  // 🔹 Applied filter values
  String? selectedCustomer;
  DateTime? startDate;
  DateTime? endDate;

  // 🔹 Temporary filter inputs
  String? tempCustomer;
  DateTime? tempStartDate;
  DateTime? tempEndDate;

  final DateFormat df = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    try {
      gstData = await GstService.fetchGstInvoices();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<String> get uniqueCustomers {
    final customers = gstData.map((e) => e.customerName).toSet().toList();
    customers.sort();
    return customers;
  }

  List<GstInvoice> get filteredData {
    return gstData.where((e) {
      final date = DateTime.tryParse(e.invoiceDate);

      if (selectedCustomer != null && e.customerName != selectedCustomer) {
        return false;
      }
      if (startDate != null && date != null && date.isBefore(startDate!)) {
        return false;
      }
      if (endDate != null && date != null && date.isAfter(endDate!)) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> pickStartDate(StateSetter setModalState) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tempStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setModalState(() => tempStartDate = picked);
  }

  Future<void> pickEndDate(StateSetter setModalState) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tempEndDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setModalState(() => tempEndDate = picked);
  }

  void openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const Text("Filter Options",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    // Customer Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Customer",
                        border: OutlineInputBorder(),
                      ),
                      value: tempCustomer,
                      items: uniqueCustomers
                          .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setModalState(() => tempCustomer = v),
                    ),
                    const SizedBox(height: 12),

                    // Date Pickers
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => pickStartDate(setModalState),
                            child: Text(tempStartDate == null
                                ? "Start Date"
                                : df.format(tempStartDate!)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => pickEndDate(setModalState),
                            child: Text(tempEndDate == null
                                ? "End Date"
                                : df.format(tempEndDate!)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedCustomer = null;
                                startDate = null;
                                endDate = null;
                                tempCustomer = null;
                                tempStartDate = null;
                                tempEndDate = null;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Clear"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedCustomer = tempCustomer;
                                startDate = tempStartDate;
                                endDate = tempEndDate;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Apply"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: openFilterSheet,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // 🔹 Table Header
          Container(
            color: Colors.grey[200],
            padding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: const Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text("Customer",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 2,
                    child: Text("Invoice",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text("Date",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text("Qty",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text("Tax",
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),

          // 🔹 Report Table/List
          Expanded(
            child: ListView.separated(
              itemCount: filteredData.length,
              separatorBuilder: (context, i) =>
                  Divider(height: 1, color: Colors.grey[300]),
              itemBuilder: (context, i) {
                final row = filteredData[i];
                return Container(
                  color: i % 2 == 0 ? Colors.grey[50] : Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(row.customerName,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(row.billNo,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: "monospace")),
                            const SizedBox(height: 2),
                            Text(row.invoiceDate,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text("${row.totalQty ?? '-'}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14)),
                      ),
                      Expanded(
                        child: Text("₹${row.totalTax}",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
