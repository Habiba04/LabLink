import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lablink/SuperAdmin/Pages/super-admin-login.dart';
import 'package:lablink/SuperAdmin/Pages/super-admin-home.dart';
import 'package:lablink/SuperAdmin/Providers/dashboard_provider.dart';
import 'package:provider/provider.dart';

class FakeDashboardProvider extends ChangeNotifier {
  bool isLoading = false;
  int totalLabs = 10;
  int activeUsers = 5;
  int testsToday = 2;
  double revenueMonth = 100.0;
  List<Map<String, dynamic>> topLabs = [
    {'name': 'Lab1', 'tests': 5, 'rating': 4.5, 'revenue': 50.0},
  ];
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
      // Mock user
      final mockUser = MockUser(
        uid: 'abc123',
        email: 'superadmin@lablink-admin.com',
      );

      // Mock FirebaseAuth
      final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: false);

      // Build our widget tree with provider
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) =>
                  FakeDashboardProvider(), // a fake provider with dummy data
            ),
            ChangeNotifierProvider(
              create: (_) =>
                  DashboardProvider(firestore: FakeFirebaseFirestore()), // a fake provider with dummy data
            ),
          ],
          child: MaterialApp(
            home: SuperAdminLoginScreen(auth: mockAuth),
            builder: (context, child) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(
                    value: Provider.of<DashboardProvider>(
                      context,
                      listen: false,
                    ),
                  ),
                ],
                child: child!,
              );
            },
          ),
        ),
      );

      // Enter valid email & password
      await tester.enterText(
        find.byKey(const Key('emailField')),
        'superadmin@lablink-admin.com',
      );
      await tester.enterText(find.byKey(const Key('passwordField')), '123456');

      // Tap the login button
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump(); // Wait for navigation

      // Expect to find the SuperAdminHomeScreen
      expect(find.byType(SuperAdminHomeScreen), findsOneWidget);
    });
  });
}
