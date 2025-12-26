import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fruit_defender/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full Game Loop E2E Test', (WidgetTester tester) async {
    // 1. Launch App
    app.main();
    await tester.pumpAndSettle();

    // 2. Click "START GAME"
    final startButton = find.text('START GAME');
    expect(startButton, findsOneWidget);
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    // 3. Click "10x" Speed Button
    final speedButton = find.text('10x');
    expect(speedButton, findsOneWidget);
    await tester.tap(speedButton);
    await tester.pumpAndSettle();

    // 4. Wait for GAME OVER
    // This might take a while even at 10x speed, so we pump repeatedly.
    // Lives = 20. Enemies spawn every 2s (at 1x) -> 0.2s (at 10x).
    // Need ~20 enemies to pass. ~4 seconds + travel time.
    // Let's settle for up to 30 seconds.
    final gameOverText = find.text('GAME OVER');
    bool found = false;
    for (int i = 0; i < 600; i++) {
      // 600 * 50ms = 30s
      await tester.pump(const Duration(milliseconds: 50));
      if (gameOverText.evaluate().isNotEmpty) {
        found = true;
        break;
      }
    }

    expect(found, isTrue,
        reason: "Game Over screen did not appear within 30 seconds");
  });
}
