
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lablink/LabAdmin/Widgets/label.dart';

void main() {
  group('buildLabel Widget Test', () {
    testWidgets('Renders text and icon with correct style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildLabel('Test Label', const Icon(Icons.star)),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);

      
      final textWidget = tester.widget<Text>(find.text('Test Label'));
      expect(textWidget.style!.fontWeight, FontWeight.bold);
      expect(textWidget.style!.fontSize, 16);
      
      
      expect(textWidget.style!.color, const Color(0xFF364153));
    });
  });
}