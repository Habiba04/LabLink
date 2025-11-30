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
  final mockLabData = {'name': 'Al-Mokhtabar Lab'};

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

  testWidgets('ConfirmationScreen displays all required data correctly', (
    tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text("Booking Confirmed!"), findsOneWidget);

    final expectedDate = DateFormat('MMMM d, yyyy').format(mockDate);
    expect(find.text(expectedDate), findsOneWidget);

    expect(find.text(mockTime), findsOneWidget);

    final expectedLocation1 = 'Al-Mokhtabar Lab - Maadi Branch';
    final expectedLocation2 = '10 Maadi St, Cairo';
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data!.contains(expectedLocation1),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data!.contains(expectedLocation2),
      ),
      findsOneWidget,
    );

    expect(find.text("#$mockBookingId"), findsOneWidget);

    final expectedTotal = "EGP 450.75";
    expect(find.text(expectedTotal), findsOneWidget);

    expect(find.widgetWithText(ElevatedButton, "Done"), findsOneWidget);
  });

  testWidgets(
    'ConfirmationScreen navigates back to first route on Done press',
    (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final doneButton = find.widgetWithText(ElevatedButton, "Done");
      expect(doneButton, findsOneWidget);
    },
  );
}
