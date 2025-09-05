import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/Jewellery_Provider/BillGetProvider.dart';
import '../../models/Jewellery_Model/billingReport.dart';
import '../../models/user_model.dart';
import '../jwellery/Jewellery_View/JwelProduct_Page/ProductView_Screen.dart';
import '../jwellery/Jewellery_View/reports/billi-order.dart';
import '../jwellery/Jewellery_View/reports/reports.dart';
import 'balance_card.dart';

class JewelleryDashboard extends StatefulWidget {
  final User user;
  const JewelleryDashboard({super.key, required this.user});

  @override
  State<JewelleryDashboard> createState() => _JewelleryDashboardState();
}

class _JewelleryDashboardState extends State<JewelleryDashboard> {
  int _selectedIndex = 0;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  late final List<Widget> _pages = [
    const BalanceCard(), // Home
    ChangeNotifierProvider(
      create: (_) => BillProvider(),
      child: const JewProductViewScreen(), // ✅
    ),
    ReportsScreen(), // ✅
    const Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  String _getPageTitle(int index) {
    switch (index) {
      case 1:
        return "Billing";
      case 2:
        return "Reports";
      case 3:
        return "Profile";
      default:
        return "Hi, ${_user.name}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar( // ✅
      //   title: Text(_getPageTitle(_selectedIndex)),
      //   backgroundColor: const Color(0xFFB8860B),
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFB8860B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Billing Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Billing'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
