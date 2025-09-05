class PartialOrderResponse {
  final String message;
  final List<OrderData> data;

  PartialOrderResponse({required this.message, required this.data});

  factory PartialOrderResponse.fromJson(Map<String, dynamic> json) {
    return PartialOrderResponse(
      message: json["message"] ?? "",
      data: (json["data"] as List)
          .map((e) => OrderData.fromJson(e))
          .toList(),
    );
  }
}

class OrderData {
  final int id;
  final String billno;
  final String date;
  final String totalPrice;
  final String grossTotal;
  final num totalPayment;
  final num duePayment;
  final String billCountNumber;
  final String createdAt;
  final List<OrderDetail> details;
  final UserData? user;
  final List<PaymentData> payments;

  OrderData({
    required this.id,
    required this.billno,
    required this.date,
    required this.totalPrice,
    required this.grossTotal,
    required this.totalPayment,
    required this.duePayment,
    required this.billCountNumber,
    required this.createdAt,
    required this.details,
    required this.user,
    required this.payments,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json["id"],
      billno: json["billno"] ?? "",
      date: json["date"] ?? "",
      totalPrice: json["total_price"] ?? "0",
      grossTotal: json["gross_total"] ?? "0",
      totalPayment: json["total_payment"] ?? 0,
      duePayment: json["due_payment"] ?? 0,
      billCountNumber: json["billcountnumber"] ?? "",
      createdAt: json["created_at"] ?? "",
      details: (json["details"] as List)
          .map((e) => OrderDetail.fromJson(e))
          .toList(),
      user: json["users"] != null ? UserData.fromJson(json["users"]) : null,
      payments: (json["payments"] as List)
          .map((e) => PaymentData.fromJson(e))
          .toList(),
    );
  }
}

class OrderDetail {
  final int id;
  final String productName;
  final String qty;
  final String rate;
  final String proTotal;

  OrderDetail({
    required this.id,
    required this.productName,
    required this.qty,
    required this.rate,
    required this.proTotal,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json["id"],
      productName: json["product_name"] ?? "",
      qty: json["qty"] ?? "0",
      rate: json["rate"] ?? "0",
      proTotal: json["pro_total"] ?? "0",
    );
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final List<CustomerData> customers;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.customers,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["id"],
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      customers: json["customers"] != null
          ? (json["customers"] as List)
          .map((e) => CustomerData.fromJson(e))
          .toList()
          : [],
    );
  }
}

class CustomerData {
  final int id;
  final String phone;
  final String address;
  final String state;

  CustomerData({
    required this.id,
    required this.phone,
    required this.address,
    required this.state,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json["id"],
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
      state: json["state"] ?? "",
    );
  }
}

class PaymentData {
  final int id;
  final String paymentMethod;
  final String price;
  final String paymentDate;

  PaymentData({
    required this.id,
    required this.paymentMethod,
    required this.price,
    required this.paymentDate,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      id: json["id"],
      paymentMethod: json["payment_method"] ?? "",
      price: json["price"] ?? "0",
      paymentDate: json["payment_date"] ?? "",
    );
  }
}
