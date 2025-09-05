import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductTileSkeleton extends StatelessWidget {
  const ProductTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(height: 12, width: 60, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 12, width: 40, color: Colors.white),
            const Spacer(),
            Container(
              height: 20,
              width: 50,
              margin: const EdgeInsets.only(bottom: 8),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
