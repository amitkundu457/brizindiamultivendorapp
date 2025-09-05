class GstInvoice {
  final int id;
  final String billNo;
  final String customerName;
  final String invoiceDate;
  final int? totalQty;
  final double totalTax;

  GstInvoice({
    required this.id,
    required this.billNo,
    required this.customerName,
    required this.invoiceDate,
    this.totalQty,
    required this.totalTax,
  });

  factory GstInvoice.fromJson(Map<String, dynamic> json) {
    return GstInvoice(
      id: json["id"] ?? 0,
      billNo: json["billno"] ?? "",
      customerName: json["customer_name"] ?? "",
      invoiceDate: json["invoice_date"] ?? "",
      totalQty: json["total_qty"] != null
          ? int.tryParse(json["total_qty"].toString())
          : null,
      totalTax: json["total_tax"] != null
          ? double.tryParse(json["total_tax"].toString()) ?? 0
          : 0,
    );
  }
}
