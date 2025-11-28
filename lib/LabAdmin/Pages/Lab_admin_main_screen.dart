import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Pages/Lab_admin_dashboard.dart';
import 'package:lablink/LabAdmin/Pages/orders_screen.dart';
import 'package:lablink/LabAdmin/Pages/analytics_report_screen.dart';
import 'package:lablink/LabAdmin/Pages/profile_screen.dart';
import 'package:lablink/LabAdmin/Pages/review_screen.dart';

class LabMainScreen extends StatefulWidget {
  const LabMainScreen({super.key});

  @override
  State<LabMainScreen> createState() => _LabMainScreenState();
}

class _LabMainScreenState extends State<LabMainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const LabDashboardScreen(),
      OrdersScreen(),
      ReviewScreen(),
      AnalyticsReportScreen(),
      ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star_rounded),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file_outlined),
            activeIcon: Icon(Icons.insert_drive_file_rounded),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF00B4DB),
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
