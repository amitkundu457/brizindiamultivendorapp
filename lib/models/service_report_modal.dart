class ServiceModel {
  final int id;
  final String name;
  final String? code;
  final String? brand;
  final String? description;
  final String rate;
  final String? image;
  final String createdAt;

  ServiceModel({
    required this.id,
    required this.name,
    this.code,
    this.brand,
    this.description,
    required this.rate,
    this.image,
    required this.createdAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'],
      brand: json['brand'],
      description: json['description'],
      rate: json['rate'] ?? '0.00',
      image: json['image'],
      createdAt: json['created_at'] ?? '',
    );
  }
}
