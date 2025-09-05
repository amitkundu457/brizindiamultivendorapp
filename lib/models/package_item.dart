class PackageItem {
  final int id;
  final String name;
  final String totalPackageAmount;

  PackageItem({
    required this.id,
    required this.name,
    required this.totalPackageAmount,
  });

  factory PackageItem.fromJson(Map<String, dynamic> json) {
    return PackageItem(
      id: json['id'],
      name: json['name'],
      totalPackageAmount: json['totalPackageAmount'] ?? '0',
    );
  }
}
