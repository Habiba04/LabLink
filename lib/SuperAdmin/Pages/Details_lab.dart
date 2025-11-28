import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lablink/LabAdmin/Widgets/Filter_Bar.dart';
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
  String _selectedTab = "Overview";
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
      if (lab != null && _tabs.isNotEmpty) {
        _selectedTab = _tabs.first;
      }
      _isLoading = false;
    });
  }

  Future<Lab?> getLabById(String labId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('lab')
        .doc(labId)
        .get();
    if (snapshot.exists) {
      return Lab.fromMap(snapshot.data()!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final int _selectedIndex = _tabs.indexOf(_selectedTab);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FilterBar(
              items: _tabs,
              selected: _selectedTab,
              onSelected: (newTab) {
                setState(() {
                  _selectedTab = newTab;
                });
              },
            ),
          ),
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
          colors: [Color(0xFFAD46FF), Color(0xFF4F39F6), Color(0xFF155DFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.6, 1.0],
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
