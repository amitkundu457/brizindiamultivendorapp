class ProductItem {
  final int id;
  final String name;
  final String? image;
  final String rate;
  final int currentStock;
  final String? expires;

  ProductItem({
    required this.id,
    required this.name,
    required this.image,
    required this.rate,
    required this.currentStock,
    required this.expires,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] == "null" ? null : json['image'],
      rate: json['rate'] ?? '0',
      currentStock: json['current_stock'] ?? 0,
      expires: json['expires'],
    );
  }
}
