import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/BillingSelectorPage.dart';
import '../../models/user_model.dart';
import '../billing_page.dart';
import '../report.dart';
import '../report/package_report.dart';
import '../report_page.dart';
import 'balance_card.dart';

class DashboardPage extends StatefulWidget {
  final User user;
  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  final List<Widget> _pages = [
    const BalanceCard(),
    const BillingSelectorPage(),
    RemoteMenuScreen(),
    Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

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
      appBar: AppBar(
        backgroundColor: const Color(0xFF16A34A),
        title: Text(
          _getPageTitle(_selectedIndex),
          style: const TextStyle(color: Colors.white),
        ),
        leading: _selectedIndex == 0
            ? null
            : IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => setState(() => _selectedIndex = 0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _user.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF16A34A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF16A34A),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Billing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
