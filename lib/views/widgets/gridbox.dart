import 'package:flutter/material.dart';

class GridBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Color bgColor;
  final double width;

  const GridBox({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.bgColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(width * 0.045),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(width * 0.035),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: width * 0.043,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: width * 0.065,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
