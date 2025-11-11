import 'package:flutter/material.dart';
import 'package:lablink/Patient/Pages/BookingHistory.dart';
import 'package:lablink/Patient/Pages/HomeScreen.dart';
import 'package:lablink/Patient/Pages/lab_details.dart';
import 'package:lablink/Patient/Pages/profile_screen.dart';


*/
// --- Main Navigation Wrapper ---

class MainScreen extends StatefulWidget {
  // Mock data needed to initialize the history screen
  final Map<String, dynamic> labData;
  final Map<String, dynamic> locationData;
  final List<Map<String, dynamic>> selectedTests;
  final String selectedService;

  const MainScreen({
    super.key,
    required this.labData,
    required this.locationData,
    required this.selectedTests,
    required this.selectedService,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Default to History tab

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      BookingHistoryScreen(),
      const ProfileScreen(),
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
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off_outlined),
            activeIcon: Icon(Icons.history_rounded),
            label: 'History',
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
