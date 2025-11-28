import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Database/firebase_DB.dart';
import 'package:lablink/Models/Lab.dart';

class AnalyticsReportScreen extends StatefulWidget {
  const AnalyticsReportScreen({super.key});
  @override
  State<AnalyticsReportScreen> createState() => _AnalyticsReportScreenState();
}

class _AnalyticsReportScreenState extends State<AnalyticsReportScreen> {
  final labId = FirebaseAuth.instance.currentUser!.uid;
  Lab? labData;
  bool _isLoading = true;
  Map<String, dynamic> monthlyData = {};
  double labVisitsRevenue = 0;
  double homeVisitsRevenue = 0;

  Future<void> _fetchLabData() async {
    setState(() => _isLoading = true);
    final _labData = await FirebaseDatabase().getLabDetails(labId);
    final results = await FirebaseDatabase().getMonthlyLabAnalytics(labId);
    final _monthlyData = results['monthlyData'] as Map<String, dynamic>;
    final _labVisitsRevenue = results['labVisitsRevenue'] as double;
    final _homeVisitsRevenue = results['homeVisitsRevenue'] as double;

    setState(() {
      labData = _labData;
      monthlyData = _monthlyData;
      labVisitsRevenue = _labVisitsRevenue;
      homeVisitsRevenue = _homeVisitsRevenue;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchLabData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (monthlyData.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No analytics data available.")),
      );
    }

    final months = monthlyData.keys.toList()..sort();
    final latestMonth = months.isNotEmpty ? months.last : null;
    final lastFourMonths = months.length > 4
        ? months.sublist(months.length - 4)
        : months;
    final lastMonthsData = lastFourMonths.map((month) {
      final data = monthlyData[month];
      return {
        'month': month,
        'tests': data['tests'].toString(),
        'revenue': '${data['revenue']} E£',
      };
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Analytics & Reports",
          style: TextStyle(fontSize: width * 0.04),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: width * 0.9,
                    height: height * 0.19,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.04),

                      gradient: LinearGradient(
                        colors: [Color(0xFF00B8DB), Color(0xFF00BBA7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Month Performance",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    monthlyData.isNotEmpty
                                        ? (monthlyData[latestMonth]?['tests']
                                                  ?.toString() ??
                                              '0')
                                        : '0',
                                    style: TextStyle(
                                      fontSize: width * 0.08,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Total Tests",
                                    style: TextStyle(
                                      color: Color(0xFFCBFBF1),
                                      fontSize: width * 0.04,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    monthlyData.isNotEmpty
                                        ? '${monthlyData[latestMonth]?['revenue'] ?? 0} E£'
                                        : '0 EGP',
                                    style: TextStyle(
                                      fontSize: width * 0.08,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Revenue",
                                    style: TextStyle(
                                      color: Color(0xFFCBFBF1),
                                      fontSize: width * 0.04,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_border,
                                      color: Color(0xFFF0B100),
                                      size: width * 0.07,
                                    ),
                                    SizedBox(width: width * 0.02),
                                    Text(
                                      "Rating",
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: width * 0.1),
                                Text(
                                  labData!.rating.toString(),
                                  style: TextStyle(
                                    fontSize: width * 0.06,

                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Average Rating",
                                  style: TextStyle(
                                    color: Color(0xFF4A5565),
                                    fontSize: width * 0.04,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.04),
                      Expanded(
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.people_alt_outlined,
                                      color: Colors.blue,
                                      size: width * 0.07,
                                    ),
                                    SizedBox(width: width * 0.02),
                                    Text(
                                      "Patients",
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: width * 0.1),
                                Text(
                                  monthlyData.isNotEmpty
                                      ? '${monthlyData[monthlyData.keys.last]?['patients'] ?? 0}'
                                      : '0',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: width * 0.06,
                                  ),
                                ),
                                Text(
                                  "Total Served",
                                  style: TextStyle(
                                    color: Color(0xFF4A5565),
                                    fontSize: width * 0.04,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Color(0xFF00BBA7),
                                size: width * 0.04,
                              ),
                              SizedBox(width: width * 0.02),
                              Text(
                                "Monthly Trend",
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Color(0xFF101828),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.04),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: lastMonthsData.length,
                            itemBuilder: (context, index) {
                              final item = lastMonthsData[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['month'].toString(),
                                    style: TextStyle(
                                      fontSize: width * 0.04,
                                      color: Color(0xFF364153),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        item['tests'].toString(),
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Color(0xFF4A5565),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.04),
                                      Text(
                                        item['revenue'].toString(),
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Color(0xFF009689),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                size: width * 0.04,
                                color: Color(0xFF00C950),
                              ),
                              Text(
                                " Revenue Breakdown",
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lab Visits",
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Color(0xFF364153),
                                ),
                              ),
                              Text(
                                "$labVisitsRevenue E£".toString(),
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Home Collections",
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Color(0xFF364153),
                                ),
                              ),
                              Text(
                                "$homeVisitsRevenue E£".toString(),
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Color(0xFFF3F4F6)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "${homeVisitsRevenue + labVisitsRevenue} E£"
                                    .toString(),
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Color(0xFF009689),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
