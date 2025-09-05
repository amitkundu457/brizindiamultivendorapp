class SaloonOrder {
  final int id;
  final String billNo;
  final String date;
  final String grossTotal;
  final String discount;
  final String totalPrice;
  final String createdAt;
  final String userName;

  SaloonOrder({
    required this.id,
    required this.billNo,
    required this.date,
    required this.grossTotal,
    required this.discount,
    required this.totalPrice,
    required this.createdAt,
    required this.userName,
  });

  factory SaloonOrder.fromJson(Map<String, dynamic> json) {
    return SaloonOrder(
      id: json['id'],
      billNo: json['billno'],
      date: json['date'],
      grossTotal: json['gross_total'],
      discount: json['discount'],
      totalPrice: json['total_price'],
      createdAt: json['created_at'],
      userName: json['users']?['name'] ?? 'N/A',
    );
  }
}
