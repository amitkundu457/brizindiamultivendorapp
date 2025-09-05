class ProductStock {
  final int id;
  final String name;
  final String? image;
  final String? rate;
  final int currentStock;

  ProductStock({
    required this.id,
    required this.name,
    this.image,
    this.rate,
    required this.currentStock,
  });

  factory ProductStock.fromJson(Map<String, dynamic> json) {
    return ProductStock(
      id: json['id'],
      name: json['name'] ?? '',
      image: (json['image'] != null && json['image'] != 'null') ? json['image'] : null,
      rate: json['rate'],
      currentStock: json['current_stock'] ?? 0,
    );
  }
}
