
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lablink/LabAdmin/Widgets/Stat_Row.dart';

void main() {
  group('StatRow Widget Tests', () {
    testWidgets('Renders label and value correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatRow(label: 'Total Patients', value: '550'),
          ),
        ),
      );

      final labelText = tester.widget<Text>(find.text('Total Patients'));
      expect(labelText.data, 'Total Patients');
      expect(labelText.style!.color, Colors.black54); 

      final valueText = tester.widget<Text>(find.text('550'));
      expect(valueText.data, '550');
      expect(valueText.style!.fontWeight, FontWeight.w600); 
    });
  });
}