class BarcodePrint {
  final int id;
  final String printedAt;
  final Product product;
  final Barcode barcode;
  final User user;

  BarcodePrint({
    required this.id,
    required this.printedAt,
    required this.product,
    required this.barcode,
    required this.user,
  });

  factory BarcodePrint.fromJson(Map<String, dynamic> json) {
    return BarcodePrint(
      id: json['id'],
      printedAt: json['printed_at'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
      barcode: Barcode.fromJson(json['barcode'] ?? {}),
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String? code;
  final String? brand;
  final String? description;
  final String? image;
  final String? rate;
  final String? hsn;

  Product({
    required this.id,
    required this.name,
    this.code,
    this.brand,
    this.description,
    this.image,
    this.rate,
    this.hsn,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'],
      brand: json['brand'],
      description: json['description'],
      image: json['image'],
      rate: json['rate'],
      hsn: json['hsn'],
    );
  }
}

class Barcode {
  final int id;
  final String barcodeNo;
  final String? sku;
  final String? itemNo;
  final int pcs;
  final String? basicRate;
  final String? purchaseRates;
  final String? saleRate;

  Barcode({
    required this.id,
    required this.barcodeNo,
    this.sku,
    this.itemNo,
    required this.pcs,
    this.basicRate,
    this.purchaseRates,
    this.saleRate,
  });

  factory Barcode.fromJson(Map<String, dynamic> json) {
    return Barcode(
      id: json['id'],
      barcodeNo: json['barcode_no'] ?? '',
      sku: json['sku'],
      itemNo: json['itemno'],
      pcs: int.tryParse(json['pcs'].toString()) ?? 0, // ✅ Fix applied here
      basicRate: json['basic_rate'],
      purchaseRates: json['purchase_rates'],
      saleRate: json['sale_rate'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String? email;

  User({
    required this.id,
    required this.name,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'],
    );
  }
}
