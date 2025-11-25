import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Models/Lab.dart';
 import 'package:lablink/SuperAdmin/Pages/Overview_tap.dart';
import 'package:lablink/SuperAdmin/Pages/Performance_tap.dart';
import 'package:lablink/SuperAdmin/Pages/location_tap.dart';
class DetailsScreen extends StatefulWidget {
  DetailsScreen({
    super.key,
    required this.labId,
    required this.tests,
    required this.activeusers,
    required this.Monthlyrevenue,
    required this.review,
  });

  final String labId;
  var tests;
  var activeusers;
  var Monthlyrevenue;
  var review;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Lab? lab;
  bool _isLoading = true;
  int _selectedIndex = 0;
  final List<String> _tabs = ["Overview", "Locations", "Performance"];

  @override
  void initState() {
    super.initState();
    fetchLab();
  }

  Future<void> fetchLab() async {
    setState(() => _isLoading = true);
    lab = await getLabById(widget.labId);
    setState(() {
      _isLoading = false;
    });
  }

  Future<Lab?> getLabById(String labId) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('lab').doc(labId).get();
    if (snapshot.exists) {
      return Lab.fromMap(snapshot.data()!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildTabBar(),
          const SizedBox(height: 20),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : IndexedStack(
                    index: _selectedIndex,
                    children: [
                      OverviewPage(
                        lab: lab,
                        tests: widget.tests,
                        activeusers: widget.activeusers,
                        Monthlyrevenue: widget.Monthlyrevenue,
                        review: widget.review,
                      ),
                      LocationsPage(labId: widget.labId),
                      PerformanceScreen(labId: widget.labId),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A5AE0), Color(0xFF4A90E2)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              lab?.name ?? 'Lab Name',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final bool isActive = _selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: isActive
                    ? BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ],
                      )
                    : null,
                alignment: Alignment.center,
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    color: isActive ? Colors.black87 : Colors.grey,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

 