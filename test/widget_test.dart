import 'package:flutter_test/flutter_test.dart';
import 'package:snake_and_ladder/main.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SnakesAndLaddersApp());

    // Verify that the splash screen shows 'JUNGLE'.
    expect(find.text('JUNGLE'), findsOneWidget);
  });
}
