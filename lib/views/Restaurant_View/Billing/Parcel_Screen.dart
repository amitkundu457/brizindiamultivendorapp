// import 'package:flutter/material.dart';
//
// class Parcel_Screen extends StatefulWidget {
//   const Parcel_Screen({super.key});
//
//   @override
//   State<Parcel_Screen> createState() => _Parcel_ScreenState();
// }
//
// class _Parcel_ScreenState extends State<Parcel_Screen> {
//   final number= TextEditingController();
//   final name= TextEditingController();
//   final numberofmembers= TextEditingController();
//   final bookingId= TextEditingController();
//   String billNo = "BILL-0001"; // Dummy Bill No
//   String? selectedCategory = "Category A";
//   String? selectedStylist = "Stylist A";
//   String? selectedFormat = "Format A";
//   String? selectedProSerType = 'Product';
//
//   DateTime? selectedDate;
//   bool showProducts = false;
//   String searchText = '';
//
//   // Dummy data
//   final categories = ["Category A", "Category B", "Category C"];
//   final stylists = ["Stylist A", "Stylist B", "Stylist C"];
//   final formats = ["Format A", "Format B"];
//
//   final List<Map<String, dynamic>> allProducts = [
//     {"id": 1, "name": "Shampoo", "rate": 100.0},
//     {"id": 2, "name": "Conditioner", "rate": 150.0},
//     {"id": 3, "name": "Hair Cut", "rate": 200.0},
//     {"id": 4, "name": "Facial", "rate": 500.0},
//   ];
//
//
//   List<Map<String, dynamic>> cartItems = [];
//
//   void _handleAddToCart(Map<String, dynamic> product, int qty) {
//     final index = cartItems.indexWhere((item) => item['id'] == product['id']);
//     if (index != -1) {
//       cartItems[index]['quantity'] = qty;
//     } else {
//       cartItems.add({...product, 'quantity': qty});
//     }
//     setState(() {});
//   }
//
//   double _calculateTotal() {
//     double total = 0;
//     for (var item in cartItems) {
//       total += (item['rate'] as double) * (item['quantity'] ?? 1);
//     }
//     return total;
//   }
//
//   Widget _buildDropdown(
//       String label,
//       String? value,
//       Function(String?) onChanged, {
//         List<String>? items,
//       }) {
//     return DropdownButtonFormField<String>(
//       decoration: const InputDecoration(
//         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//         border: OutlineInputBorder(),
//       ),
//       value: value,
//       hint: Text(label),
//       onChanged: onChanged,
//       items: items
//           ?.map((e) => DropdownMenuItem(value: e, child: Text(e)))
//           .toList() ??
//           [],
//     );
//   }
//
//   Widget _buildLabel(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: Colors.black54,
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final isSmallScreen = width < 600;
//     final filteredProducts = searchText.isEmpty
//         ? allProducts
//         : allProducts
//         .where((p) =>
//         (p['name'] ?? '').toString().toLowerCase().contains(searchText.toLowerCase()))
//         .toList();
//
//
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF16A34A),
//         title: const Text(
//           "Table Booking",
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//               _buildLabel("Enter Number"),
//               SizedBox(height: 4,),
//               TextFormField(
//                 controller: number,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//                   hintText: "Enter Number",
//                 ),
//               ),
//               const SizedBox(height: 12),
//               _buildLabel("Enter Name"),
//               SizedBox(height: 4,),
//               TextFormField(
//                 controller: name,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//                   hintText: "Enter Name",
//                   //labelText: "Enter Name"
//                 ),
//               ),
//               const SizedBox(height: 12),
//               _buildLabel("Select Parcel Type"),
//               SizedBox(height: 4,),
//               _buildDropdown(
//                 "Select Parcel Type",
//                 selectedFormat,
//                     (val) => setState(() => selectedFormat = val),
//                 items: formats,
//               ),
//               const SizedBox(height: 12),
//               _buildLabel("Select Category"),
//               SizedBox(height: 4,),
//               _buildDropdown(
//                 "Select Category",
//                 selectedFormat,
//                     (val) => setState(() => selectedFormat = val),
//                 items: formats,
//               ),
//               const SizedBox(height: 20),
//           ],
//         ),
//       ),
//       bottomNavigationBar: !showProducts
//           ? Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ElevatedButton.icon(
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 14),
//             backgroundColor: const Color(0xFF16A34A),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           onPressed: () => setState(() => showProducts = true),
//           icon: const Icon(Icons.arrow_forward, color: Colors.white),
//           label: const Text(
//             "Continue",
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white),
//           ),
//         ),
//       )
//           : cartItems.isNotEmpty
//           ? Container(
//         padding:
//         const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: Offset(0, -2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Total: ₹${_calculateTotal().toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                       content: Text("Checkout pressed")),
//                 );
//               },
//               child: const Text("Checkout"),
//             ),
//           ],
//         ),
//       )
//           : null,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/RestorentProvider/RestroProductServices/ParcelProvider.dart';

class Parcel_Screen extends StatefulWidget {
  const Parcel_Screen({super.key});

  @override
  State<Parcel_Screen> createState() => _Parcel_ScreenState();
}

class _Parcel_ScreenState extends State<Parcel_Screen> {
  final number = TextEditingController();
  final name = TextEditingController();

  String? selectedParcelType;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ParcelProvider>(context, listen: false);
      provider.fetchParcelTypes();
      provider.fetchCategories();
    });
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ParcelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parcel Booking"),
        backgroundColor: const Color(0xFF16A34A),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
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
            const SizedBox(height: 12),
            _buildLabel("Enter Name"),
            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Name",
              ),
            ),
            const SizedBox(height: 12),

            /// 🚀 Parcel Type Dropdown (API se)
            _buildLabel("Select Parcel Type"),
            DropdownButtonFormField<String>(
              value: selectedParcelType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              hint: const Text("Select Parcel Type"),
              items: provider.parcelTypes
                  .map((e) => DropdownMenuItem<String>(
                value: e["id"].toString(),
                child: Text(e["type"].toString()), // ✅ "type" use karo
              ))
                  .toList(),
              onChanged: (val) => setState(() => selectedParcelType = val),
            ),

            const SizedBox(height: 12),

            /// 🚀 Category Dropdown (kot-tables API se)
            _buildLabel("Select Category"),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              hint: const Text("Select Category"),
              items: provider.categories
                  .map((e) => DropdownMenuItem<String>(
                value: e["id"].toString(),
                child: Text(e["name"].toString()), // ✅ use 'name'
              ))
                  .toList(),

              onChanged: (val) =>
                  setState(() => selectedCategory = val),
            ),
            const SizedBox(height: 20),
          ],

        ),
      ),
      /// 🚀 Bottom Checkout Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xFF16A34A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            // 👇 Yaha apna checkout logic likho
            print("Checkout Clicked");
            print("Number: ${number.text}");
            print("Name: ${name.text}");
            print("Parcel Type: $selectedParcelType");
            print("Category: $selectedCategory");
          },
          child: const Text(
            "Checkout",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
