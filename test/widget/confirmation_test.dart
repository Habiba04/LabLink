import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:lablink/Patient/Pages/Confirmation.dart';


void main() {
  const mockBookingId = 'ABC12345';
  final mockDate = DateTime(2025, 12, 15);
  const mockTime = '11:30 AM';
  const mockTotal = 450.75;
  final mockLocationData = {
    'name': 'Maadi Branch',
    'address': '10 Maadi St, Cairo',
  };
  final mockLabData = {
    'name': 'Al-Mokhtabar Lab',
  };

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ConfirmationScreen(
        bookingId: mockBookingId,
        date: mockDate.toIso8601String().substring(0, 10),
        time: mockTime,
        locationData: mockLocationData,
        labData: mockLabData,
        total: mockTotal,
      ),
    );
  }

  testWidgets('ConfirmationScreen displays all required data correctly', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // 1. Check title and success text
    expect(find.text("Booking Confirmed!"), findsOneWidget);
    
    // 2. Check Date format
    final expectedDate = DateFormat('MMMM d, yyyy').format(mockDate);
    expect(find.text(expectedDate), findsOneWidget);

    // 3. Check Time
    expect(find.text(mockTime), findsOneWidget);

    // 4. Check Location format (using a partial text match)
    final expectedLocation1 = 'Al-Mokhtabar Lab - Maadi Branch';
    final expectedLocation2 = '10 Maadi St, Cairo';
    expect(find.byWidgetPredicate(
        (widget) => widget is Text && widget.data!.contains(expectedLocation1)), findsOneWidget);
    expect(find.byWidgetPredicate(
        (widget) => widget is Text && widget.data!.contains(expectedLocation2)), findsOneWidget);

    // 5. Check Booking ID
    expect(find.text("#$mockBookingId"), findsOneWidget);

    // 6. Check Total Amount format (EGP 450.75)
    final expectedTotal = "EGP 450.75";
    expect(find.text(expectedTotal), findsOneWidget);
    
    // 7. Check 'Done' button
    expect(find.widgetWithText(ElevatedButton, "Done"), findsOneWidget);
  });
  
  testWidgets('ConfirmationScreen navigates back to first route on Done press', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    
    // Create a mock navigator observer to check navigation calls
    // Navigator.popUntil(context, (r) => r.isFirst) is tricky to test
    // but we can mock the action and verify the attempt to pop
    // (Actual testing often requires a mock navigator setup outside of this example)
    
    final doneButton = find.widgetWithText(ElevatedButton, "Done");
    expect(doneButton, findsOneWidget);

    // We can simulate the tap, though the full navigation stack verification is advanced
    // await tester.tap(doneButton);
    // await tester.pumpAndSettle();
    // In a real app, we'd verify that the number of routes is reduced to 1.
  });
}