import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/dashboard/saloon_dashboard.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import 'jewellery_dashboard.dart';
import 'restaurant_dashboard.dart';

class MainDashboardLoader extends StatefulWidget {
  const MainDashboardLoader({super.key});

  @override
  State<MainDashboardLoader> createState() => _MainDashboardLoaderState();
}

class _MainDashboardLoaderState extends State<MainDashboardLoader> {
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final user = await AuthService.fetchUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_user == null || _user!.roles.isEmpty) {
      return const Scaffold(body: Center(child: Text("No role assigned")));
    }

    final role = _user!.roles.first.name.toLowerCase();
    if (role == "saloon") {
      return Saloon_DashboardPage(user: _user!);
    } else if (role == "jwellery") {
      return JewelleryDashboard(user: _user!);
    } else if (role == "resturant") {
      return RestaurantDashboard_Page(user: _user!);
    } else {
      return const Scaffold(body: Center(child: Text("Unknown role")));
    }
  }
}
