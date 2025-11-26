import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lablink/SuperAdmin/Pages/super-admin-home.dart';
import 'package:lablink/SuperAdmin/Pages/super-admin-login.dart';
import 'package:lablink/SuperAdmin/Providers/dashboard_provider.dart';
import 'package:provider/provider.dart';

<<<<<<< Updated upstream
import '../unit/dashboard_provider_unit_test.dart'; // the FakeDashboardProvider
=======
import '../unit/dashboard_provider_unit_test.dart';

>>>>>>> Stashed changes

void main() {
  testWidgets("Shows loading indicator", (tester) async {
    final provider = FakeDashboardProvider()..isLoading = true;
    final mockAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: "123", email: "normal@test.com"),
    );

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

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Displays dashboard stats", (tester) async {
    final provider = FakeDashboardProvider();
<<<<<<< Updated upstream

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: SuperAdminHomeScreen(),
        ),
=======
    final mockAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: "123", email: "normal@test.com"),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DashboardProvider>(
            create: (_) => provider,
          ),
        ],
        child: MaterialApp(home: SuperAdminLoginScreen(auth: mockAuth)),
>>>>>>> Stashed changes
      ),
    );

    await tester.pump();

<<<<<<< Updated upstream
    expect(find.text("5"), findsOneWidget);
    expect(find.text("20"), findsOneWidget);
    expect(find.text("7"), findsOneWidget);
    expect(find.text("£1000.50"), findsOneWidget);
=======
    expect(find.text("Total Labs"), findsOneWidget);
    expect(find.text("3"), findsOneWidget);
    expect(find.text("1"), findsOneWidget);
    expect(find.text("£1150.00"), findsOneWidget);
>>>>>>> Stashed changes
  });

  testWidgets("Logout navigates to login", (tester) async {
    final provider = FakeDashboardProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DashboardProvider>.value(value: provider),
        ],
        child: MaterialApp(home: SuperAdminHomeScreen()),
      ),
    );

    // Tap the Logout button
    await tester.tap(find.byKey(Key('logoutButton')));
    await tester.pumpAndSettle();

    // Expect to navigate back to login screen
    expect(find.byType(SuperAdminLoginScreen), findsOneWidget);
  });
}
