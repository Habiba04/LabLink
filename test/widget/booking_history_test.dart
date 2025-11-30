import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:lablink/Patient/Pages/BookingHistory.dart';
import 'package:lablink/Patient/providers/appointment_provider.dart';
import 'package:lablink/Models/Appointment.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

final mockUser = MockUser(uid: 'test-user-uid', email: 'test@example.com');
final mockAuth = MockFirebaseAuth(mockUser: mockUser);

class MockAppointmentNotifier extends Mock implements AppointmentNotifier {
  @override
  String? get error =>
      super.noSuchMethod(Invocation.getter(#error), returnValue: null);
  @override
  List<Appointment> get appointments => super.noSuchMethod(
    Invocation.getter(#appointments),
    returnValue: <Appointment>[],
  );
  @override
  bool get isLoading =>
      super.noSuchMethod(Invocation.getter(#isLoading), returnValue: false);
}

void main() {
  late MockAppointmentNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockAppointmentNotifier();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<AppointmentNotifier>.value(
        value: mockNotifier,
        child: const BookingHistoryScreen(),
      ),
    );
  }

  testWidgets('Renders CircularProgressIndicator when loading', (tester) async {
    when(mockNotifier.isLoading).thenReturn(true);
    when(mockNotifier.appointments).thenReturn([]);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Renders empty message when no appointments exist', (
    tester,
  ) async {
    when(mockNotifier.isLoading).thenReturn(false);
    when(mockNotifier.appointments).thenReturn([]);
    when(mockNotifier.error).thenReturn(null);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text("You have no booking history."), findsOneWidget);
  });

  testWidgets(
    'Renders custom sign-in error message on user-not-signed-in error',
    (tester) async {
      when(mockNotifier.isLoading).thenReturn(false);
      when(mockNotifier.appointments).thenReturn([]);
      when(mockNotifier.error).thenReturn('user-not-signed-in');

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Please sign in to view your history.'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    },
  );
}
