import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lablink/Database/firebase_DB.dart';

class PerformanceScreen extends StatefulWidget {
  final String labId;
  const PerformanceScreen({super.key, required this.labId});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  final FirebaseDatabase db = FirebaseDatabase();
  Map<String, dynamic>? monthlyData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMonthlyAnalytics();
  }

  Future<void> fetchMonthlyAnalytics() async {
    try {
      final data = await db.getMonthlyLabAnalytics(widget.labId);

      if (data.isEmpty ||
          data['monthlyData'] == null ||
          data['monthlyData'].isEmpty) {
        final Map<String, dynamic> defaultData = {};
        final now = DateTime.now();
        for (int i = 5; i >= 0; i--) {
          final month = DateTime(now.year, now.month - i, 1);
          final key = DateFormat('MMM yyyy').format(month);
          defaultData[key] = {'patients': 0, 'tests': 0, 'revenue': 0.0};
        }
        setState(() {
          monthlyData = defaultData;
          isLoading = false;
        });
      } else {
        setState(() {
          monthlyData = Map<String, dynamic>.from(data['monthlyData']);
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error fetching monthly analytics: $e');
      setState(() {
        monthlyData = {};
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7fb),
      body: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Monthly Performance",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...monthlyData!.entries.map((entry) {
                            final month = entry.key;
                            final data = entry.value;
                            return Column(
                              children: [
                                buildItem(
                                  month,
                                  data['tests'].toString(),
                                  "£${(data['revenue'] as double).toStringAsFixed(2)}",
                                ),
                                buildDivider(),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildItem(String month, String tests, String revenue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          month,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tests Completed",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(tests, style: const TextStyle(fontSize: 15)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Revenue",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(
                  revenue,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: Colors.grey.withOpacity(0.3), thickness: 1),
    );
  }
}
