class DineInModel {
  final int id;
  final String name;

  DineInModel({required this.id, required this.name});

  factory DineInModel.fromJson(Map<String, dynamic> json) {
    return DineInModel(id: json['id'], name: json['name'] ?? '');
  }
}

class DineInStylist {
  final int id;
  final String name;

  DineInStylist({required this.id, required this.name});

  factory DineInStylist.fromJson(Map<String, dynamic> json) {
    return DineInStylist(id: json['id'], name: json['name']);
  }
}