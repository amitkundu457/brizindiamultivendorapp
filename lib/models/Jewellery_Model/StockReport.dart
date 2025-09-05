class StockItem {
  final int id;
  final String name;
  final String? image;
  final String rate;
  final String code;
  final int? taxRate;
  final int currentStock;
  final int availableQuantity;

  StockItem({
    required this.id,
    required this.name,
    this.image,
    required this.rate,
    required this.code,
    this.taxRate,
    required this.currentStock,
    required this.availableQuantity,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      id: json["id"],
      name: json["name"] ?? "No name",
      image: json["image"],
      rate: json["rate"] ?? "0",
      code: json["code"] ?? "",
      taxRate: json["tax_rate"],
      currentStock: json["current_stock"] ?? 0,
      availableQuantity: json["available_quantity"] ?? 0,
    );
  }
}
