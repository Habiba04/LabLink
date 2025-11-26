

import 'package:lablink/Models/SimpleOrder.dart';

class DashboardData {
  final int pendingRequests;
  final int completedTests;
  final double avgRating;
  final double earningsThisMonth;
  final int todaysBookings;
  final int activePatients;
  final List<SimpleOrder> recentOrders;

  DashboardData({
    required this.pendingRequests,
    required this.completedTests,
    required this.avgRating,
    required this.earningsThisMonth,
    required this.todaysBookings,
    required this.activePatients,
    required this.recentOrders,
    
  });

  factory DashboardData.empty() => DashboardData(
        pendingRequests: 0,
        completedTests: 0,
        avgRating: 0,
        earningsThisMonth: 0,
        todaysBookings: 0,
        activePatients: 0,
        recentOrders: const [],
      );
}
