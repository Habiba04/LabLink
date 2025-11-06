import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lablink/LabAdmin/Pages/appointmentScreen.dart';
// Assuming this is your data model
import 'package:lablink/Models/Orders.dart';

class LabDashboardScreen extends StatefulWidget {
  const LabDashboardScreen({super.key});

  @override
  State<LabDashboardScreen> createState() => _LabDashboardScreenState();
}

class _LabDashboardScreenState extends State<LabDashboardScreen> {
  // Dummy data structure for the Order model (assuming a basic class definition)
  final List<Order> allOrders = [
    Order(
      name: 'Sarah Johnson',
      test: 'Complete Blood Count',
      time: '30 mins ago',
      status: 'New',
      statusColor: const Color(0xFFFFE8D6),
      textColor: const Color(0xFFFF7B00),
    ),
    Order(
      name: 'Mike Chen',
      test: 'Lipid Profile',
      time: '1 hour ago',
      status: 'New',
      statusColor: const Color(0xFFFFE8D6),
      textColor: const Color(0xFFFF7B00),
    ),
    Order(
      name: 'Emma Wilson',
      test: 'Thyroid Test',
      time: '2 hours ago',
      status: 'Accepted',
      statusColor: const Color(0xFFD4F9E6),
      textColor: const Color(0xFF00BBA7),
    ),
    Order(
      name: 'John Doe',
      test: 'Blood Sugar Test',
      time: '3 hours ago',
      status: 'New',
      statusColor: const Color(0xFFFFE8D6),
      textColor: const Color(0xFFFF7B00),
    ),
  ];

  // Navigation Handler Function
  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F7),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header
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
                  // Lab Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Central Diagnostics",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Welcome back, Admin",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                  // Profile Circle
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Text(
                      "CD",
                      style: TextStyle(
                        color: Color(0xFF00BBA7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 🔹 Four small cards (stats)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildStatCard(
                      icon: FontAwesomeIcons.clock,
                      iconColor: Colors.orange,
                      value: '12',
                      label: 'Pending Requests',
                    ),
                    _buildStatCard(
                      icon: FontAwesomeIcons.circleCheck,
                      iconColor: Colors.green,
                      value: '145',
                      label: 'Completed Tests',
                    ),
                    _buildStatCard(
                      icon: FontAwesomeIcons.star,
                      iconColor: Colors.amber,
                      value: '4.8',
                      label: 'Avg. Rating',
                    ),
                    _buildStatCard(
                      icon: Icons.currency_pound,
                      iconColor: Colors.blue,
                      value: 'EGP 45,600',
                      label: 'This Month',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // 🔹 Quick Stats Card
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
                  children: const [
                    Row(
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
                    SizedBox(height: 10),
                    _StatRow(label: "Today's Bookings", value: '24'),
                    _StatRow(label: "Active Patients", value: '156'),
                    _StatRow(label: "Response Time", value: '~15 mins'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const SizedBox(height: 12),

            // Order cards header
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

            // Show only first 3 orders
            Column(
              children: allOrders.take(3).map((order) {
                return _OrderCard(
                  name: order.name,
                  test: order.test,
                  time: order.time,
                  status: order.status,
                  statusColor: order.statusColor,
                  textColor: order.textColor,
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // 🔹 Admin Management section
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
                    child: _AdminButton(
                      label: 'Locations',
                      icon: Icons.location_on_outlined,
                      borderColor: const Color(0xFF00BBA7),
                      onTap: () {
                        // Dummy navigation for Locations
                        print('Navigating to Locations Screen');
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _AdminButton(
                      label: 'Appointments',
                      icon: Icons.calendar_today_outlined,
                      borderColor: const Color(0xFF00B4DB),
                      onTap: () {
                        // Navigate to AppointmentsScreen
                        _navigateToScreen(context, AppointmentsScreen());
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// --- Common Widgets ---

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

Widget _buildStatCard({
  required IconData icon,
  required Color iconColor,
  required String value,
  required String label,
}) {
  return Container(
    width: 170,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
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
        CircleAvatar(
          radius: 18,
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
      ],
    ),
  );
}

class _OrderCard extends StatelessWidget {
  final String name;
  final String test;
  final String time;
  final String status;
  final Color statusColor;
  final Color textColor;

  const _OrderCard({
    required this.name,
    required this.test,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              test,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 🚀 MODIFIED WIDGET: Added final VoidCallback? onTap
class _AdminButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color borderColor;
  final VoidCallback? onTap; // New property for tap handling

  const _AdminButton({
    required this.label,
    required this.icon,
    required this.borderColor,
    this.onTap, // Optional tap handler
  });

  @override
  Widget build(BuildContext context) {
    // Wrap the content in an InkWell for tap detection and visual feedback
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.2),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: borderColor),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: borderColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
