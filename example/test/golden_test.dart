import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('Counter should display well', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Match the golden file.
    await expectLater(find.byType(MyApp), matchesGoldenFile('golden_test.png'));
  });
}
