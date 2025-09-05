class Role {
  final String name;

  Role({required this.name});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}

class User {
  final String name;
  final String email;
  final UserInformation? information;
  final List<Role> roles; // ✅ Added

  User({
    required this.name,
    required this.email,
    this.information,
    required this.roles, // ✅ Added
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      information: json['information'] != null
          ? UserInformation.fromJson(json['information'])
          : null,
      roles: (json['roles'] as List<dynamic>?)?.map((roleJson) {
        return Role.fromJson(roleJson);
      }).toList() ??
          [], // ✅ Safe parse
    );
  }
}

class UserInformation {
  final String businessName;
  final String mobileNumber;
  final String email;
  final String gst;

  UserInformation({
    required this.businessName,
    required this.mobileNumber,
    required this.email,
    required this.gst,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
      businessName: json['business_name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      email: json['email'] ?? '',
      gst: json['gst'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'business_name': businessName,
      'mobile_number': mobileNumber,
      'email': email,
      'gst': gst,
    };
  }
}
