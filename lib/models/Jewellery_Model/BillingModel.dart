class Product {
  final int id;
  final String? groupId;
  final String name;
  final String? mrp;
  final String image;
  final double rate;
  final String? code;
  final String? type;
  final int? taxRate;
  final String? hsn;
  final String? brand;
  final String? description;
  final String? proSerType;
  final String? expires;
  final int? currentStock;
  final String? totalQuantity;

  Product({
    required this.id,
    this.groupId,
    required this.name,
    this.mrp,
    required this.image,
    required this.rate,
    this.code,
    this.type,
    this.taxRate,
    this.hsn,
    // this.mrp,
    this.brand,
    this.description,
    this.proSerType,
    this.expires,
    this.currentStock,
    this.totalQuantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      groupId: json['group_id']?.toString(),
      name: json['name'] ?? '',
      mrp: json['mrp']?.toString(),
      image: json['image']?.toString() ?? '',
      rate: double.tryParse(json['rate'].toString()) ?? 0.0,
      code: json['code']?.toString(),
      type: json['type']?.toString(),
      taxRate: json['tax_rate'] as int?,
      hsn: json['hsn']?.toString(),
      brand: json['brand']?.toString(),
      description: json['description']?.toString(),
      proSerType: json['pro_ser_type']?.toString(),
      expires: json['expires']?.toString(),
      currentStock: json['current_stock'] as int?,
      totalQuantity: json['total_quantity']?.toString(),
    );
  }
}
