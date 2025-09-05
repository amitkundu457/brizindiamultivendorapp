class CategoryReport {
  final String category;
  final String name;
  final double totalPrice;
  final int qty;
  final DateTime createdAt;

  CategoryReport({
    required this.category,
    required this.name,
    required this.totalPrice,
    required this.qty,
    required this.createdAt,
  });

  factory CategoryReport.fromJson(Map<String, dynamic> json) {
    return CategoryReport(
      category: json['category'] ?? "",
      name: json['name'] ?? "",
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      qty: int.tryParse(json['qty'].toString()) ?? 0,
      createdAt: DateTime.tryParse(json['created_at'].toString()) ??
          DateTime.now(),
    );
  }
}
