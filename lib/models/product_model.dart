class Product {
  final int id;
  final String name;
  final String? image;
  final String? rate;
  final String? code;
  final int? taxRate;
  final int? qty;
  final String? createdAt; // ✅ Add this line

  Product({
    required this.id,
    required this.name,
    this.image,
    this.rate,
    this.taxRate,
    this.qty,
    this.code,
    this.createdAt, // ✅ Include in constructor
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] == 'null' ? null : json['image'],
      rate: json['rate'],
      taxRate: json['tax_rate'],
      qty: json['qty'],
      code: json['code'],
      createdAt: json['created_at'], // ✅ Parse it from JSON
    );
  }
}
