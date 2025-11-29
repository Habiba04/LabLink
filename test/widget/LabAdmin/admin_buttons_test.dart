// test/lab_admin/widgets/admin_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lablink/LabAdmin/Widgets/Admin_Button.dart';

void main() {
  group('AdminButton Widget Tests', () {
    testWidgets('Renders label and icon with correct color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdminButton(
              label: 'Test Button',
              icon: Icons.access_alarms,
              color: Colors.red,
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byIcon(Icons.access_alarms), findsOneWidget);

      // Check icon color
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.access_alarms));
      expect(iconWidget.color, Colors.red);

      // Check text color
      final textWidget = tester.widget<Text>(find.text('Test Button'));
      expect(textWidget.style!.color, Colors.red);
    });

    testWidgets('Tapping button calls onTap callback', (tester) async {
      bool wasTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdminButton(
              label: 'Tap Me',
              icon: Icons.check,
              color: Colors.green,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pump();

      expect(wasTapped, true);
    });
  });
}