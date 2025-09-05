class AssignedPackage {
  final String packageNo;
  final String receiptNo;
  final String packageName;
  final String packageAmount;
  final String serviceAmount;
  final String paidAmount;
  final String remainingAmount;
  final String paymentDate;
  final String packageBooking;
  final String packageExpiry;
  final String packageId;
  final String packageStatus;
  final String paymentStatus;
  final Customer? customer;
  final UserInfo? user;

  AssignedPackage({
    required this.packageNo,
    required this.receiptNo,
    required this.packageName,
    required this.packageAmount,
    required this.serviceAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.paymentDate,
    required this.packageBooking,
    required this.packageExpiry,
    required this.packageId,
    required this.packageStatus,
    required this.paymentStatus,
    this.customer,
    this.user,
  });

  factory AssignedPackage.fromJson(Map<String, dynamic> json) {
    return AssignedPackage(
      packageNo: json['package_no'] ?? '',
      receiptNo: json['receipt_no'] ?? '',
      packageName: json['package_name'] ?? '',
      packageAmount: json['package_amount']?.toString() ?? '',
      serviceAmount: json['service_amount']?.toString() ?? '',
      paidAmount: json['paid_amount']?.toString() ?? '',
      remainingAmount: json['remaining_amount']?.toString() ?? '',
      paymentDate: json['payment_date'] ?? '',
      packageBooking: json['package_booking'] ?? '',
      packageExpiry: json['package_expiry'] ?? '',
      packageId: json['package_id']?.toString() ?? '',
      packageStatus: json['package_status']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      user: json['users'] != null ? UserInfo.fromJson(json['users']) : null,
    );
  }
}

class Customer {
  final String? phone;
  final String? gender;
  final String? address;
  final String? state;
  final String? country;

  Customer({
    this.phone,
    this.gender,
    this.address,
    this.state,
    this.country,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      phone: json['phone'],
      gender: json['gender'],
      address: json['address'],
      state: json['state'],
      country: json['country'],
    );
  }
}

class UserInfo {
  final int? id;
  final String? name;
  final String? email;

  UserInfo({
    this.id,
    this.name,
    this.email,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
