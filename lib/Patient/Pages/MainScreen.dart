import 'package:flutter/material.dart';
import 'package:lablink/Patient/Pages/BookingHistory.dart';
import 'package:lablink/Patient/Pages/lab_details.dart';

// --- Mock Screens for Navigation ---

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Home Dashboard",
            style: TextStyle(fontSize: 24, color: Colors.blueGrey),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LabDetails(labId: "KQKp1xBfKO3OCVU3SO9w"),
                ),
              );
            },
            icon: Icon(Icons.arrow_circle_right_outlined),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Patient Profile",
        style: TextStyle(fontSize: 24, color: Colors.blueGrey),
      ),
    );
  }
}

// --- Main Navigation Wrapper ---

class MainScreen extends StatefulWidget {
  // Mock data needed to initialize the history screen
  final Map<String, dynamic> mockLabData;
  final Map<String, dynamic> mockLocationData;
  final List<Map<String, dynamic>> mockSelectedTests;
  final String mockSelectedService;

  const MainScreen({
    super.key,
    required this.mockLabData,
    required this.mockLocationData,
    required this.mockSelectedTests,
    required this.mockSelectedService,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Default to History tab

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      BookingHistoryScreen(
        mockLabData: widget.mockLabData,
        mockLocationData: widget.mockLocationData,
        mockSelectedTests: widget.mockSelectedTests,
        mockSelectedService: widget.mockSelectedService,
      ),
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
