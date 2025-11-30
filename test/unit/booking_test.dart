import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:lablink/Patient/Services/BookingService.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  final User? mockUser;
  final bool? signedIn;

  MockFirebaseAuth({this.mockUser, this.signedIn});

  @override
  User? get currentUser => mockUser;
}

class MockUser extends Mock implements User {
  @override
  final String uid;
  @override
  final String? email;

  MockUser({required this.uid, this.email});
}

void setupFirebaseAuthMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

void main() {
  setupFirebaseAuthMocks();

  final mockLabData = {'id': 'lab123', 'name': 'TestLab'};
  final mockLocationData = {
    'id': 'loc123',
    'name': 'BranchX',
    'address': '123 Test St',
  };
  final mockTests = [
    {'id': 'testA', 'name': 'Blood Test', 'price': 100.0},
    {'id': 'testB', 'name': 'Urine Test', 'price': 250.0},
  ];

  group('BookingService Unit Tests', () {
    test(
      'calculateTotal should return correct total with no home collection',
      () {
        final mockAuth = MockFirebaseAuth();
        final service = BookingService(
          auth: mockAuth,
          labData: mockLabData,
          locationData: mockLocationData,
          selectedTests: mockTests,
          selectedService: "Visit Lab",
        );

        final total = service.calculateTotal();

        expect(total, 350.0);
      },
    );

    test('calculateTotal should include home collection charge', () {
      final mockAuth = MockFirebaseAuth();
      final service = BookingService(
        auth: mockAuth,
        labData: mockLabData,
        locationData: mockLocationData,
        selectedTests: mockTests,
        selectedService: "Home Collection",
      );
      final total = service.calculateTotal();

      expect(total, 400.0);
    });

    test(
      'getCurrentUserId should throw exception if user is not signed in',
      () {
        final mockAuth = MockFirebaseAuth(signedIn: false);
        final service = BookingService(
          auth: mockAuth,
          labData: mockLabData,
          locationData: mockLocationData,
          selectedTests: mockTests,
          selectedService: "Visit Lab",
        );

        expect(
          () => service.getCurrentUserId(),
          throwsA(
            isA<FirebaseAuthException>().having(
              (e) => e.code,
              'code',
              'user-not-signed-in',
            ),
          ),
        );
      },
    );
  });
}
