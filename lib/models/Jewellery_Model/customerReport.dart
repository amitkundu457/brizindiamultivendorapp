class Customer {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final int totalOrders;
  final String? orderBillNos;
  final String? orderTotals;

  Customer({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    required this.totalOrders,
    this.orderBillNos,
    this.orderTotals,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["id"],
      name: json["customer_name"] ?? json["name"] ?? "",
      phone: json["phone"],
      email: json["email"],
      address: json["address"],
      totalOrders: json["total_orders"] ?? 0,
      orderBillNos: json["order_billnos"],
      orderTotals: json["order_totals"],
    );
  }
}
