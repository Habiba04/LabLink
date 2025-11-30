import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lablink/SuperAdmin/Providers/dashboard_provider.dart';

class FakeDashboardProvider extends DashboardProvider {
  FakeDashboardProvider() : super(firestore: FakeFirebaseFirestore());

  @override
  void listenDashboard() {
    totalLabs = 5;
    activeUsers = 20;
    testsToday = 7;
    revenueMonth = 1000.50;
    topLabs = [
      {"name": "Alpha", "tests": 15, "rating": 4.1, "revenue": 500.0},
    ];
    notifyListeners();
  }
}

void main() {
  test("DashboardProvider loads dashboard data correctly", () {
    final provider = FakeDashboardProvider();

    provider.listenDashboard();

    expect(provider.totalLabs, 5);
    expect(provider.activeUsers, 20);
    expect(provider.testsToday, 7);
    expect(provider.revenueMonth, 1000.50);
    expect(provider.topLabs.first['name'], "Alpha");
  });
}
