import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:lablink/SuperAdmin/Pages/super-admin-login.dart';
import 'package:lablink/SuperAdmin/Pages/super-admin-home.dart';
import 'package:lablink/SuperAdmin/Providers/dashboard_provider.dart';
import 'package:provider/provider.dart';

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

  group("SuperAdminLoginScreen widget tests", () {
    testWidgets("Login screen renders fields", (tester) async {
      final mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: "123", email: "normal@test.com"),
      );

      await tester.pumpWidget(
        MaterialApp(home: SuperAdminLoginScreen(auth: mockAuth)),
      );

      expect(find.byKey(Key('emailField')), findsOneWidget);
      expect(find.byKey(Key('passwordField')), findsOneWidget);
      expect(find.byKey(Key('loginButton')), findsOneWidget);
    });

    testWidgets("Displays unauthorized snackbar", (tester) async {
      final mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: "123", email: "normal@test.com"),
      );

      await tester.pumpWidget(
        MaterialApp(home: SuperAdminLoginScreen(auth: mockAuth)),
      );

      await tester.enterText(find.byKey(Key('emailField')), "normal@test.com");
      await tester.enterText(find.byKey(Key('passwordField')), "123456");

      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text("Not authorized as Super Admin"), findsOneWidget);
    });

    testWidgets('After successful login, navigates to SuperAdminHomeScreen', (
      WidgetTester tester,
    ) async {
      final mockUser = MockUser(email: 'superadmin@lablink-admin.com');

      final mockAuth = MockFirebaseAuth(mockUser: mockUser);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DashboardProvider>(
              create: (_) => FakeDashboardProvider(),
            ),
          ],
          child: MaterialApp(home: SuperAdminLoginScreen(auth: mockAuth)),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('emailField')),
        'superadmin@lablink-admin.com',
      );
      await tester.enterText(find.byKey(const Key('passwordField')), '123456');

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.byType(SuperAdminHomeScreen), findsOneWidget);
    });
  });
}
