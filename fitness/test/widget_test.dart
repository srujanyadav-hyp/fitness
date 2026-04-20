import 'package:flutter_test/flutter_test.dart';
import 'package:fitness/main.dart';

void main() {
  testWidgets('FitHubApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FitHubApp());
    // Verify the app renders without crashing.
    expect(find.byType(FitHubApp), findsOneWidget);
  });
}
