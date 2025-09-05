class Customer {
  final int? id;
  final String? name;
  final String? address;
  final String? phone;

  Customer({this.id, this.name, this.address, this.phone});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}
