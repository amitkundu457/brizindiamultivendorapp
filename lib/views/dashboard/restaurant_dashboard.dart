import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class RestaurantDashboard extends StatelessWidget {
  final User user;
  const RestaurantDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant Dashboard")),
      body: Center(child: Text("Welcome ${user.name}")),
    );
  }
}
