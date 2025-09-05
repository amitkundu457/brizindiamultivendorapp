import 'package:flutter/material.dart';
import '../../models/product_model.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback? onAdd;

  const ProductTile({super.key, required this.product, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Product Image with fallback ---
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child:
                product.image != null && product.image != 'null'
                    ? Image.network(
                      'https://apibrize.brizindia.com/storage/${product.image}',
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildNoImage(),
                    )
                    : _buildNoImage(),
          ),

          // --- Product Name ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // --- Price and GST ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${product.rate ?? '0.00'}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "GST ${product.taxRate ?? 0}%",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // --- Add Button ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(double.infinity, 36),
              ),
              child: const Text("Add", style: TextStyle(fontSize: 14)),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// Reusable "No Image" widget
  Widget _buildNoImage() {
    return Container(
      height: 100,
      color: Colors.grey.shade200,
      width: double.infinity,
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
      ),
    );
  }
}
