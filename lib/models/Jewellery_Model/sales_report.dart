class SalesReport {
  final String billno;
  final String customerName;
  final String productName;
  final int qty;
  final double rate;
  final String paymentDate;
  final String paymentMethod;
  final double price;
  final String createdAt;

  SalesReport({
    required this.billno,
    required this.customerName,
    required this.productName,
    required this.qty,
    required this.rate,
    required this.paymentDate,
    required this.paymentMethod,
    required this.price,
    required this.createdAt,
  });

  factory SalesReport.fromJson(Map<String, dynamic> json) {
    return SalesReport(
      billno: json['billno'] ?? '',
      customerName: json['customer_name'] ?? '',
      productName: json['product_name'] ?? '',
      qty: int.tryParse(json['qty']?.toString() ?? '0') ?? 0,
      rate: double.tryParse(json['rate']?.toString() ?? '0') ?? 0.0,
      paymentDate: json['payment_date'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at'] ?? '',
    );
  }
}
