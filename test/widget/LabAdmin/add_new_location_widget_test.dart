import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lablink/LabAdmin/Pages/Add_New_Location.dart';

class FakeLocationServices {
  Future<void> addLocation(dynamic location, String labid) async {
    await Future.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  testWidgets('AddNewLocation form fields and submit button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: AddNewLocation()));
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(6));
    expect(find.text('Add Location'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'e.g., Main Branch, North Branch'),
      'Main Branch',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter complete address'),
      'Street 123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, '+1 (555) 123-4567'),
      '0123456789',
    );

    await tester.tap(find.text('Add Location'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });
}
