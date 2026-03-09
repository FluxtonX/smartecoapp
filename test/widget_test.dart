import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarteco/main.dart';

void main() {
  testWidgets('SmartEcoApp renders splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartEcoApp());

    // Verify that the splash screen shows SmartEco
    expect(find.text('SmartEco'), findsOneWidget);
  });
}
