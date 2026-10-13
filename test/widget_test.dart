import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_buddy/widgets/stat_card.dart';

void main() {
  testWidgets('StatCard renders title, value and icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatCard(
            title: 'Pending Tasks',
            value: '5',
            icon: Icons.hourglass_bottom_rounded,
            accentColor: Colors.deepPurple,
          ),
        ),
      ),
    );

    expect(find.text('5'), findsOneWidget);
    expect(find.text('Pending Tasks'), findsOneWidget);
    expect(find.byIcon(Icons.hourglass_bottom_rounded), findsOneWidget);
  });
}
