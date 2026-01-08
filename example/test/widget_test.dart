// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('Calculator app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: CalculatorApp()));

    // Verify that the calculator starts with 0 display
    expect(find.text('0'), findsOneWidget);
  });
}
