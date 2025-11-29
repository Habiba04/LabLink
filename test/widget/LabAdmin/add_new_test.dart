
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lablink/LabAdmin/Pages/Add_New_Test.dart';

void main() {
  group('AddNewTest Widget Tests', () {
    testWidgets('Renders all required form fields and dropdowns', (tester) async {
      const mockLocationId = 'loc1';
      const mockLabId = 'lab1';
      await tester.pumpWidget(
        MaterialApp(
          home: AddNewTest(locationId: mockLocationId, labid: mockLabId),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add New Test'), findsOneWidget);
      expect(find.text('Test Name'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Duration'), findsOneWidget);
      expect(find.text('Sample Type'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Preparation Instructions (Optional)'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Add Test'), findsOneWidget);

      
      expect(find.byWidgetPredicate((widget) => widget is DropdownButtonFormField<String>), findsNWidgets(2));
    });

  });
}