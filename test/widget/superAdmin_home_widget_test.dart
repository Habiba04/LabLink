import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lablink/SuperAdmin/Pages/super-admin-home.dart';
import 'package:lablink/SuperAdmin/Providers/dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class FakeDashboardProvider extends ChangeNotifier
    implements DashboardProvider {
  @override
  FirebaseFirestore get firestore => FakeFirebaseFirestore();

  @override
  bool isLoading = false;
  @override
  int totalLabs = 10;
  @override
  int activeUsers = 5;
  @override
  int testsToday = 2;
  @override
  double revenueMonth = 100.0;
  @override
  List<Map<String, dynamic>> topLabs = [
    {'name': 'Lab1', 'tests': 5, 'rating': 4.5, 'revenue': 50.0},
  ];
  @override
  void listenDashboard() {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Displays dashboard stats", (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DashboardProvider>(
            create: (_) => FakeDashboardProvider(),
          ),
        ],
        child: MaterialApp(home: SuperAdminHomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("5"), findsOneWidget);
    expect(find.text("10"), findsOneWidget);
    expect(find.text("2"), findsOneWidget);
    expect(find.text("£100.00"), findsOneWidget);
  });
}
