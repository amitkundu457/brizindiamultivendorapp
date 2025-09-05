class BillingReport {
  final String billNo;
  final String billDate;
  final String customerName;
  final String customerPhone;
  final int orderSlip;
  final String billInv;
  final int quantity;
  final String totalPrice;
  final String orderDate;
  final int pdfId;

  BillingReport({
    required this.billNo,
    required this.billDate,
    required this.customerName,
    required this.customerPhone,
    required this.orderSlip,
    required this.billInv,
    required this.quantity,
    required this.totalPrice,
    required this.orderDate,
    required this.pdfId,
  });

  factory BillingReport.fromJson(Map<String, dynamic> json) {
    return BillingReport(
      billNo: json['billno'],
      billDate: json['bill_date'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      orderSlip: json['order_slip'],
      billInv: json['bill_inv'],
      quantity: json['quantity'],
      totalPrice: json['total_price'],
      orderDate: json['order_date'],
      pdfId: json['pdf_id'],
    );
  }
}
