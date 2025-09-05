import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedStylist;
  String? selectedFormat;

  final List<String> stylists = ['All', 'Shivangi', 'Rahul', 'Priya'];
  final List<String> formats = ['All', 'Invoice', 'Estimate'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Reports")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Filter Row
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    "Start Date",
                    startDate,
                        (date) => setState(() => startDate = date),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDateField(
                    "End Date",
                    endDate,
                        (date) => setState(() => endDate = date),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row(
            //   children: [
            //     Expanded(
            //       child: _buildDropdown(
            //         "Stylist",
            //         selectedStylist,
            //         stylists,
            //         (val) => setState(() => selectedStylist = val),
            //       ),
            //     ),
            //     const SizedBox(width: 8),
            //     Expanded(
            //       child: _buildDropdown(
            //         "Format",
            //         selectedFormat,
            //         formats,
            //         (val) => setState(() => selectedFormat = val),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 20),

            // Summary Cards
            Row(
              children: [
                _buildSummaryCard(
                  "Total Invoices",
                  "45",
                  Icons.receipt_long,
                  Colors.green,
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  "Total Sales",
                  "₹1,25,000",
                  Icons.attach_money,
                  Colors.indigo,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Report List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Invoices",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.download_rounded, color: Colors.green),
                  onPressed: () {
                    // Export logic here
                  },
                ),
              ],
            ),

            // Report List Table
            Expanded(
              child: ListView.builder(
                itemCount: 10, // example data
                itemBuilder:
                    (context, index) => Card(
                  child: ListTile(
                    title: Text("INV/MK/2025-${702 + index}"),
                    subtitle: const Text("Stylist: Shivangi"),
                    trailing: const Text(
                      "₹2,500",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(
      String label,
      DateTime? date,
      Function(DateTime) onSelect,
      ) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: date != null ? "${date.day}/${date.month}/${date.year}" : "",
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onSelect(picked);
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _buildDropdown(
      String hint,
      String? selected,
      List<String> options,
      Function(String?) onChanged,
      ) {
    return DropdownButtonFormField<String>(
      value: selected,
      onChanged: onChanged,
      hint: Text(hint),
      decoration: const InputDecoration(border: OutlineInputBorder()),
      items:
      options
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
    );
  }

  Widget _buildSummaryCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
