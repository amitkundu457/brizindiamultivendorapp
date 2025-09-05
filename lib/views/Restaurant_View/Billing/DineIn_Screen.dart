//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../controllers/RestorentProvider/RestroProductServices/DineInProvider.dart';

// class DineInScreen extends StatefulWidget {
//   const DineInScreen({super.key});
//
//   @override
//   State<DineInScreen> createState() => _DineInScreenState();
// }
//
// class _DineInScreenState extends State<DineInScreen> {
//   final number = TextEditingController();
//   final name = TextEditingController();
//   final numberOfMembers = TextEditingController();
//   final bookingId = TextEditingController();
//
//   String? selectedFormat;
//   String? selectedCategory;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = Provider.of<DineInProvider>(context, listen: false);
//       provider.fetchBillingFormats();
//       provider.fetchCategories();
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<DineInProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Table Booking"),
//         backgroundColor: const Color(0xFF16A34A),
//         foregroundColor: Colors.white,
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildLabel("Enter Number"),
//             TextFormField(
//               controller: number,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Enter Number",
//               ),
//             ),
//             const SizedBox(height: 10),
//             _buildLabel("Enter Name"),
//             TextFormField(
//               controller: name,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Enter Name",
//               ),
//             ),
//             const SizedBox(height: 10),
//             _buildLabel("Enter Number of Members"),
//             TextFormField(
//               controller: numberOfMembers,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Enter Number of Members",
//               ),
//             ),
//             const SizedBox(height: 10),
//             _buildLabel("Enter Booking ID"),
//             TextFormField(
//               controller: bookingId,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Enter Booking ID",
//               ),
//             ),
//             const SizedBox(height: 10),
//             _buildLabel("Table No"),
//             DropdownButtonFormField<String>(
//               value: selectedFormat,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//               hint: const Text("Table No"),
//               items: provider.billingFormats
//                   .map((e) => DropdownMenuItem<String>(
//                 value: e["id"].toString(),
//                 child: Text(e["table_no"].toString()), // ✅ "table_no" instead of "name"
//               ))
//                   .toList(),
//               onChanged: (val) => setState(() => selectedFormat = val),
//             ),
//             const SizedBox(height: 10),
//             _buildLabel("Select Category"),
//             DropdownButtonFormField<String>(
//               value: selectedCategory,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//               hint: const Text("Select Category"),
//               items: provider.categories
//                   .map((e) => DropdownMenuItem<String>(
//                 value: e["id"].toString(),
//                 child: Text(e["name"].toString()),
//               ))
//                   .toList(),
//               onChanged: (val) => setState(() => selectedCategory = val),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF16A34A),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               onPressed: () async {
//                 final body = {
//                   "number": number.text,
//                   "name": name.text,
//                   "number_of_members": numberOfMembers.text,
//                   "booking_id": bookingId.text,
//                   "billing_format": selectedFormat,
//                   "category": selectedCategory,
//                 };
//
//                 bool success = await provider.bookTable(body);
//                 if (success && mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Booking Successful")),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Booking Failed")),
//                   );
//                 }
//               },
//               child: const Text("Checkout"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLabel(String text) => Padding(
//     padding: const EdgeInsets.only(bottom: 4),
//     child: Text(
//       text,
//       style: const TextStyle(
//           fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/RestorentProvider/RestroProductServices/DineInProvider.dart';

class DineInScreen extends StatefulWidget {
  const DineInScreen({super.key});

  @override
  State<DineInScreen> createState() => _DineInScreenState();
}

class _DineInScreenState extends State<DineInScreen> {
  final number = TextEditingController();
  final name = TextEditingController();
  final numberOfMembers = TextEditingController();
  final bookingId = TextEditingController();

  String? selectedFormat;
  String? selectedCategory;

  bool showBillingScreen = false;
  Map<String, dynamic>? bookingData;

  // 🔎 Search + Filter vars
  String searchQuery = "";
  double? minPrice;
  double? maxPrice;

  // Dummy Products
  final List<Map<String, dynamic>> products = [
    {
      "name": "face wash",
      "price": 500,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpxu9VXxjYenrfY1cHWaO1IqVVo2wHIy_AWw&s",
    },
    {
      "name": "face cream",
      "price": 200,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpxu9VXxjYenrfY1cHWaO1IqVVo2wHIy_AWw&s",
    },
    {
      "name": "Lorial",
      "price": 200,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpxu9VXxjYenrfY1cHWaO1IqVVo2wHIy_AWw&s",
    },
    {
      "name": "demos",
      "price": 34,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpxu9VXxjYenrfY1cHWaO1IqVVo2wHIy_AWw&s",
    },
    {
      "name": "face wash",
      "price": 500,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpxu9VXxjYenrfY1cHWaO1IqVVo2wHIy_AWw&s",
    },
    {
      "name": "face cream",
      "price": 200,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpxu9VXxjYenrfY1cHWaO1IqVVo2wHIy_AWw&s",
    },
    {
      "name": "Lorial",
      "price": 200,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpxu9VXxjYenrfY1cHWaO1IqVVo2wHIy_AWw&s",
    },
    {
      "name": "demos",
      "price": 34,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpxu9VXxjYenrfY1cHWaO1IqVVo2wHIy_AWw&s",
    },
  ];

  // 🛒 Cart Map {productName: quantity}
  final Map<String, int> cart = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DineInProvider>(context, listen: false);
      provider.fetchKotTable();
      provider.fetchCategories();
      provider.fetchProducts(); // 👈 yaha call karein
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          showBillingScreen ? "Product/Service Billing" : "Table Booking",
        ),
        backgroundColor: const Color(0xFF16A34A),
        foregroundColor: Colors.white,
        //actions: showBillingScreen
      ),
      body: showBillingScreen ? _buildBillingUI() : _buildBookingForm(),
    );
  }

  /// Booking Form UI
  Widget _buildBookingForm() {
    final provider = Provider.of<DineInProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Enter Number"),
          TextFormField(
            controller: number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Number",
            ),
          ),
          const SizedBox(height: 10),
          _buildLabel("Enter Name"),
          TextFormField(
            controller: name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Name",
            ),
          ),
          const SizedBox(height: 10),
          _buildLabel("Enter Number of Members"),
          TextFormField(
            controller: numberOfMembers,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Members",
            ),
          ),
          const SizedBox(height: 10),
          _buildLabel("Enter Booking ID"),
          TextFormField(
            controller: bookingId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Booking ID",
            ),
          ),
          const SizedBox(height: 10),
          _buildLabel("Table No"),
          DropdownButtonFormField<String>(
            value: selectedFormat,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            hint: const Text("Table No"),
            items:
                provider.billingFormats.map<DropdownMenuItem<String>>((e) {
                  final status = e["status"].toString();
                  final isAvailable = status == "available";

                  return DropdownMenuItem<String>(
                    value: isAvailable ? e["id"].toString() : null,
                    // ❌ booked table not selectable
                    enabled: isAvailable,
                    // ❌ disables booked
                    child: Text(
                      e["table_no"].toString(),
                      style: TextStyle(
                        color: isAvailable ? Colors.green : Colors.red,
                        // ✅ Green / Red
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => selectedFormat = val);
              }
            },
          ),
          const SizedBox(height: 10),
          _buildLabel("Select Category"),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            hint: const Text("Select Category"),
            items:
                provider.categories
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e["id"].toString(),
                        child: Text(e["name"].toString()),
                      ),
                    )
                    .toList(),
            onChanged: (val) => setState(() => selectedCategory = val),
          ),
          const SizedBox(height: 20),

          /// Checkout Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              bookingData = {
                "number": number.text,
                "name": name.text,
                "number_of_members": numberOfMembers.text,
                "booking_id": bookingId.text,
                "billing_format": selectedFormat,
                "category": selectedCategory,
              };
              setState(() => showBillingScreen = true);
            },
            child: const Text("Checkout",style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  /// Billing Screen UI
  Widget _buildBillingUI() {
    final provider = Provider.of<DineInProvider>(context);

    // Loading state
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 🔎 Filter Logic
    final filteredProducts =
        provider.products.where((p) {
          final matchesSearch = p["name"].toString().toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
          final price = double.tryParse(p["rate"].toString()) ?? 0;
          final matchesMin = minPrice == null || price >= minPrice!;
          final matchesMax = maxPrice == null || price <= maxPrice!;
          return matchesSearch && matchesMin && matchesMax;
        }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      hintText: "Search Item",
                    ),
                    onChanged: (val) {
                      setState(() => searchQuery = val);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_alt_outlined),
                  onPressed: () => _showFilterDialog(),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                filteredProducts.isEmpty
                    ? const Center(child: Text("No products found"))
                    : ListView.builder(
                      itemCount: filteredProducts.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        final name = product["name"].toString();
                        final price =
                            double.tryParse(product["rate"].toString()) ?? 0;
                        final quantity = cart[name] ?? 0;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: _buildProductImage(product["image"]),
                            title: Text(name),
                            subtitle: Text(
                              "₹${price * (quantity == 0 ? 1 : quantity)}.00",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (quantity > 0)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (cart[name] != null &&
                                            cart[name]! > 0) {
                                          cart[name] = cart[name]! - 1;
                                        }
                                      });
                                    },
                                  ),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Color(0xFF16A34A),
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      cart[name] = (cart[name] ?? 0) + 1;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ₹${_calculateTotal(provider.products)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                ),
                onPressed: () {
                  print("Proceeding to checkout with cart: $cart");
                },
                child: const Text("Checkout",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Calculate total cart price
  int _calculateTotal(List<Map<String, dynamic>> products) {
    int total = 0;
    cart.forEach((name, qty) {
      final product = products.firstWhere(
        (p) => p["name"].toString() == name,
        orElse: () => {},
      );
      if (product.isNotEmpty) {
        total +=
            ((double.tryParse(product["rate"].toString()) ?? 0).toInt()) * qty;
      }
    });
    return total;
  }

  /// Price Filter Dialog
  void _showFilterDialog() {
    final minController = TextEditingController(
      text: minPrice?.toString() ?? "",
    );
    final maxController = TextEditingController(
      text: maxPrice?.toString() ?? "",
    );
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Filter by Price"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: minController,
                  decoration: const InputDecoration(
                    labelText: "Min Price",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: maxController,
                  decoration: const InputDecoration(
                    labelText: "Max Price",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    minPrice =
                        minController.text.isNotEmpty
                            ? double.tryParse(minController.text)
                            : null;
                    maxPrice =
                        maxController.text.isNotEmpty
                            ? double.tryParse(maxController.text)
                            : null;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Apply"),
              ),
            ],
          ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    final fullUrl = (imageUrl != null && imageUrl.isNotEmpty)
        ? "https://apibrize.brizindia.com/storage/$imageUrl"
        : null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade200,
        ),
        child: fullUrl != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            fullUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildNoImage();
            },
          ),
        )
            : _buildNoImage(),
      ),
    );
  }

  Widget _buildNoImage() {
    return Container(
      color: Colors.grey,
      alignment: Alignment.center,
      child: const Text(
        "No Image",
        style: TextStyle(
          fontSize: 10,
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
    ),
  );
}
