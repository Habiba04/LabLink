
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lablink/LabAdmin/Widgets/top_widget.dart';

void main() {
  group('top_screen Widget Test', () {
    testWidgets('Renders title and subtitle and back button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return top_screen(
                context: context,
                title: 'Test Title',
                subtitle: 'Test Subtitle',
              );
            },
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);

      
      final titleText = tester.widget<Text>(find.text('Test Title'));
      expect(titleText.style!.fontWeight, FontWeight.bold);
    });

    testWidgets('Back button pops the current route', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => top_screen(
                            context: context,
                            title: 'Second Screen',
                          ),
                        ),
                      );
                    },
                    child: const Text('Go'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.text('Second Screen'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      
      expect(find.text('Go'), findsOneWidget);
    });
  });
}