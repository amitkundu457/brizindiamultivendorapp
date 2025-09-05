import 'package:flutter/material.dart';
import '../../../../models/Jewellery_Model/StockReport.dart';
import '../../../../services/StockServices.dart';


class StockReportScreen extends StatefulWidget {
  final String title;
  const StockReportScreen({super.key, required this.title});

  @override
  State<StockReportScreen> createState() => _ProductReportScreenState();
}

class _ProductReportScreenState extends State<StockReportScreen> {
  List<StockItem> stockList = [];
  List<StockItem> filteredList = [];
  bool isLoading = true;
  String query = "";

  @override
  void initState() {
    super.initState();
    loadStock();
  }

  Future<void> loadStock() async {
    try {
      final data = await StockService.fetchStock();
      setState(() {
        stockList = data;
        filteredList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void filterStock(String value) {
    setState(() {
      query = value.toLowerCase();
      filteredList = stockList
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by product name...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: filterStock,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, i) {
                final item = filteredList[i];
                return Card(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: item.image != null
                        ? Image.network(
                      "https://apibrize.brizindia.com/storage/${item.image}",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.inventory, size: 40),
                    title: Text(item.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    subtitle: Text("Code: ${item.code}\nRate: ₹${item.rate}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Stock: ${item.currentStock}",
                            style: const TextStyle(color: Colors.green)),
                        Text("Available: ${item.availableQuantity}",
                            style: const TextStyle(color: Colors.blue)),
                      ],
                    ),
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
