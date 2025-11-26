import 'package:flutter/material.dart';

import '../../Database/firebaseDB.dart';
import '../../Models/Lab.dart';

class OverviewPage extends StatefulWidget {
  final Lab? lab;
  final dynamic tests;
  final dynamic activeusers;
  final dynamic Monthlyrevenue;
  final dynamic review;

  const OverviewPage({
    super.key,
    required this.lab,
    this.tests,
    this.activeusers,
    this.Monthlyrevenue,
    this.review,
  });

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  Lab? dataLabDetails;

  @override
  void initState() {
    super.initState();
    fetchLabDetails();
  }

  fetchLabDetails() async {
    if (widget.lab == null) return;
    try {
      dataLabDetails = await FirebaseDatabase().getLabDetails(widget.lab!.id);
      setState(() {});
    } catch (e) {
      print('Error fetching lab details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  Icons.monitor_heart,
                  Colors.purple,
                  "${widget.tests}",
                  "Total Tests",
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  Icons.people,
                  Colors.blue,
                  "${widget.activeusers}",
                  "Active Users",
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  Icons.currency_pound,
                  Colors.green,
                  '£${widget.Monthlyrevenue}',
                  "Monthly Revenue",
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  Icons.star,
                  Colors.orange,
                  '${widget.review}',
                  "Rating",
                  isGrowth: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Contact Information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildContactRow(
                  Icons.email_outlined,
                  "${widget.lab?.email ?? 'N/A'}",
                ),
                const SizedBox(height: 15),
                _buildContactRow(
                  Icons.phone_outlined,
                  "${widget.lab?.phone ?? 'N/A'}",
                ),
                const SizedBox(height: 15),
                _buildContactRow(
                  Icons.location_on_outlined,
                  dataLabDetails != null && dataLabDetails!.locations.isNotEmpty
                      ? dataLabDetails!.locations
                            .map((loc) => loc.address)
                            .join(", ")
                      : "Address not available",
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    Color color,
    String value,
    String label, {
    bool isGrowth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.purple, size: 20),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
