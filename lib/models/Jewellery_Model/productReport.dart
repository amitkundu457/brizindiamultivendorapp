class ProductReport {
  final int id;
  final String groupId;
  final String name;
  final String mrp;
  final String? image;
  final String rate;
  final String code;
  final String type;
  final int taxRate;
  final String hsn;
  final String? brand;
  final String? description;
  final String? proSerType;
  final String? expires;
  final int currentStock;
  final String totalQuantity;

  ProductReport({
    required this.id,
    required this.groupId,
    required this.name,
    required this.mrp,
    this.image,
    required this.rate,
    required this.code,
    required this.type,
    required this.taxRate,
    required this.hsn,
    this.brand,
    this.description,
    this.proSerType,
    this.expires,
    required this.currentStock,
    required this.totalQuantity,
  });

  factory ProductReport.fromJson(Map<String, dynamic> json) {
    return ProductReport(
      id: json['id'],
      groupId: json['group_id'].toString(),
      name: json['name'] ?? '',
      mrp: json['mrp'] ?? '0.0',
      image: json['image'],
      rate: json['rate'] ?? '0.0',
      code: json['code'] ?? '',
      type: json['type'].toString(),
      taxRate: json['tax_rate'] ?? 0,
      hsn: json['hsn'] ?? '',
      brand: json['brand'],
      description: json['description'],
      proSerType: json['pro_ser_type'],
      expires: json['expires'],
      currentStock: json['current_stock'] ?? 0,
      totalQuantity: json['total_quantity'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'name': name,
      'mrp': mrp,
      'image': image,
      'rate': rate,
      'code': code,
      'type': type,
      'tax_rate': taxRate,
      'hsn': hsn,
      'brand': brand,
      'description': description,
      'pro_ser_type': proSerType,
      'expires': expires,
      'current_stock': currentStock,
      'total_quantity': totalQuantity,
    };
  }
}
