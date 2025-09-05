class PackageNumbers {
  final String packageNo;
  final String receiptNo;

  PackageNumbers({
    required this.packageNo,
    required this.receiptNo,
  });

  factory PackageNumbers.fromJson(Map<String, dynamic> json) {
    return PackageNumbers(
      packageNo: json['package_no'] ?? '',
      receiptNo: json['receipt_no'] ?? '',
    );
  }
}
