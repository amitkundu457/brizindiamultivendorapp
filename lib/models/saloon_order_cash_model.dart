class BillReport {
  final int id;
  final String billNo;
  final String date;
  final String grossTotal;
  final String discount;
  final String totalPrice;
  final String createdAt;
  final User user;

  BillReport({
    required this.id,
    required this.billNo,
    required this.date,
    required this.grossTotal,
    required this.discount,
    required this.totalPrice,
    required this.createdAt,
    required this.user,
  });

  factory BillReport.fromJson(Map<String, dynamic> json) {
    return BillReport(
      id: json['id'],
      billNo: json['billno'] ?? '',
      date: json['date'] ?? '',
      grossTotal: json['gross_total'] ?? '0.00',
      discount: json['discount'] ?? '0.00',
      totalPrice: json['total_price'] ?? '0.00',
      createdAt: json['created_at'] ?? '',
      user: User.fromJson(json['users']),
    );
  }

  // Computed fields for UI display
  String get customerName => user.name;
  String get invoiceNo => billNo;
  String get paymentMethod => "Cash";
  String get totalAmount => totalPrice;
}

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
