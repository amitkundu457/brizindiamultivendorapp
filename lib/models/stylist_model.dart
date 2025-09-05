class Stylist {
  final int id;
  final String name;

  Stylist({required this.id, required this.name});

  factory Stylist.fromJson(Map<String, dynamic> json) {
    return Stylist(id: json['id'], name: json['name']);
  }
}
