class MembershipReport {
  final int id;
  final String memberNumber;
  final String saleDate;
  final String amount;
  final String expiryDate;
  final String status;
  final Customer customer;
  final Plan plan;
  final Stylist stylist;

  MembershipReport({
    required this.id,
    required this.memberNumber,
    required this.saleDate,
    required this.amount,
    required this.expiryDate,
    required this.status,
    required this.customer,
    required this.plan,
    required this.stylist,
  });

  factory MembershipReport.fromJson(Map<String, dynamic> json) {
    return MembershipReport(
      id: json['id'],
      memberNumber: json['member_number'] ?? '',
      saleDate: json['sale_date'] ?? '',
      amount: json['amount'] ?? '0.00',
      expiryDate: json['expiry_date'] ?? '',
      status: json['status'] ?? '',
      customer: Customer.fromJson(json['customer']),
      plan: Plan.fromJson(json['plan']),
      stylist: Stylist.fromJson(json['stylist']),
    );
  }
}

class Customer {
  final int id;
  final String name;
  final String email;

  Customer({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class Plan {
  final int id;
  final String name;
  final String fees;
  final int validity;
  final String discount;

  Plan({
    required this.id,
    required this.name,
    required this.fees,
    required this.validity,
    required this.discount,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      name: json['name'] ?? '',
      fees: json['fees'] ?? '0.00',
      validity: json['validity'] ?? 0,
      discount: json['discount'] ?? '0.00',
    );
  }
}

class Stylist {
  final int id;
  final String name;
  final String expertise;

  Stylist({
    required this.id,
    required this.name,
    required this.expertise,
  });

  factory Stylist.fromJson(Map<String, dynamic> json) {
    return Stylist(
      id: json['id'],
      name: json['name'] ?? '',
      expertise: json['expertise'] ?? '',
    );
  }
}
