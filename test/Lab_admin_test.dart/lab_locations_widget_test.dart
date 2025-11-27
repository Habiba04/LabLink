import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lablink/LabAdmin/Pages/Lab_Locations.dart';

class MockLocation {
  final String id;
  final String name;
  final String address;
  final String phone;
  final List<String> workingDays;
  final String openAt;
  final String closeAt;
  final List<String> tests;

  MockLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.workingDays,
    required this.openAt,
    required this.closeAt,
    required this.tests,
  });
}

class FakeLocationServices {
  Stream<List<MockLocation>> getLocations(String labid) {
    final locations = [
      MockLocation(
        id: '1',
        name: 'Lab A',
        address: 'Street 123',
        phone: '0123456789',
        workingDays: ['Sat', 'Sun'],
        openAt: '8:00',
        closeAt: '16:00',
        tests: ['Test1', 'Test2'],
      ),
      MockLocation(
        id: '2',
        name: 'Lab B',
        address: 'Street 456',
        phone: '0987654321',
        workingDays: ['Mon', 'Tue'],
        openAt: '9:00',
        closeAt: '17:00',
        tests: ['Test3'],
      ),
    ];

    return Stream.value(locations);
  }
}

void main() {
  testWidgets('LabLocations_screen displays locations correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: LabLocations_screen()));

    await tester.pumpAndSettle();

    expect(find.text('Lab A'), findsOneWidget);
    expect(find.text('Lab B'), findsOneWidget);

    expect(find.text('Street 123'), findsOneWidget);
    expect(find.text('Street 456'), findsOneWidget);

    expect(find.text('0123456789'), findsOneWidget);
    expect(find.text('0987654321'), findsOneWidget);

    expect(find.text('2 tests'), findsOneWidget);
    expect(find.text('1 tests'), findsOneWidget);
  });
}
