import 'package:flutter/material.dart';

import 'package:lablink/LabAdmin/Widgets/AdminButton.dart';
import 'package:lablink/LabAdmin/Widgets/HomeOrderCard.dart';
import 'package:lablink/LabAdmin/Widgets/StatCard.dart';
import 'package:lablink/LabAdmin/Widgets/StatRow.dart';
import 'package:lablink/Models/DashboardData.dart';

import 'package:lablink/LabAdmin/Pages/appointment_screen.dart';
import '../Utils/firestore_helpers.dart';

class LabDashboardScreen extends StatefulWidget {
  const LabDashboardScreen({super.key});

  @override
  State<LabDashboardScreen> createState() => _LabDashboardScreenState();
}

class _LabDashboardScreenState extends State<LabDashboardScreen> {
  String _labName = 'Loading...';
  String _labInitials = 'LD';

  @override
  void initState() {
    super.initState();
    fetchLabInfo().then((info) {
      setState(() {
        _labName = info.name;
        _labInitials = info.initials;
      });
    });
  }

  Stream<DashboardData> get dashboardStream =>
      FirestoreHelpers.dashboardStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DashboardData>(
      stream: dashboardStream,
      builder: (context, snap) {
        final dashboard = snap.data ?? DashboardData.empty();
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F8F7),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00B4DB), Color(0xFF00BBA7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    top: 70,
                    left: 20,
                    right: 20,
                    bottom: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _labName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Welcome back, Admin",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Text(
                          _labInitials,
                          style: const TextStyle(
                            color: Color(0xFF00BBA7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Top Stat Cards
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        buildStatCard(
                          dashboard.pendingRequests,
                          'Pending Requests',
                          icon: Icons.alarm,
                          color: Colors.orange,
                        ),
                        buildStatCard(
                          dashboard.completedTests,
                          'Completed Tests',
                          icon: Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                        buildStatCard(
                          dashboard.avgRating.toStringAsFixed(1),
                          'Avg. Rating',
                          icon: Icons.star_outline,
                          color: Colors.amber,
                        ),
                        buildStatCard(
                          'EGP ${dashboard.earningsThisMonth.toStringAsFixed(0)}',
                          'This Month',
                          icon: Icons.currency_pound,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Quick Stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: Color(0xFF00BBA7),
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Quick Stats',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF003B3C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        StatRow(
                          label: "Today's Bookings",
                          value: dashboard.todaysBookings.toString(),
                        ),
                        StatRow(
                          label: "Active Patients",
                          value: dashboard.activePatients.toString(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Recent Orders',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF003B3C),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Column(
                  children: dashboard.recentOrders.map((o) {
                    return OrderCard(order: o);
                  }).toList(),
                ),

                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Admin Management',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF003B3C),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: AdminButton(
                          label: 'Locations',
                          icon: Icons.location_on_outlined,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AdminButton(
                          label: 'Appointments',
                          icon: Icons.calendar_today_outlined,
                          color: Colors.blue,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AppointmentsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
