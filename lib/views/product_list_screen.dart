// import 'package:flutter/material.dart';
// import '../services/product_service.dart';
// import '../models/product_model.dart';

// class ProductListScreen extends StatefulWidget {
//   const ProductListScreen({super.key});

//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   late Future<List<Product>> _futureProducts;

//   @override
//   void initState() {
//     super.initState();
//     _futureProducts = ProductService.fetchProducts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Products & Services")),
//       body: FutureBuilder<List<Product>>(
//         future: _futureProducts,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No products available."));
//           }

//           final products = snapshot.data!;
//           return ListView.builder(
//             itemCount: products.length,
//             itemBuilder: (_, index) {
//               final product = products[index];
//               return ListTile(
//                 leading:
//                     product.image != null && product.image != "null"
//                         ? Image.network(
//                           "https://apibrize.brizindia.com/${product.image}",
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                         )
//                         : const Icon(Icons.image_not_supported),
//                 title: Text(product.name),
//                 subtitle: Text(
//                   "Type: ${product.proSerType} | Rate: ₹${product.rate ?? 'N/A'}",
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
