import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:fruit_defender/game/fruit_defender_game.dart';
import 'package:fruit_defender/ui/start_screen.dart';

void main() {
  testWidgets('Start Screen Overlay Test', (WidgetTester tester) async {
    // Build the app (or just the GameWidget)
    // We can't easily pump the full MyApp because of main(), so we reconstruct the GameWidget structure
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GameWidget<FruitDefenderGame>.controlled(
            gameFactory: FruitDefenderGame.new,
            overlayBuilderMap: {
              'StartScreen': (context, game) => StartScreen(game: game),
              'GameUI': (context, game) => Container(), // Mock GameUI
              'GameOver': (context, game) => Container(), // Mock GameOver
            },
            initialActiveOverlays: const ['StartScreen'],
          ),
        ),
      ),
    );

    await tester.pump(); // Initial frame

    // 1. Verify Start Screen is visible
    expect(find.text('FRUIT DEFENDER'), findsOneWidget);
    expect(find.text('START GAME'), findsOneWidget);

    // 2. Tap Start
    await tester.tap(find.text('START GAME'));
    await tester.pump();
    await tester.pump(); // Allow overlays to update

    // 3. Verify Start Screen is GONE (removed from headers/overlays)
    // In actual app, overlays.remove causes rebuild.
    // In tests, sometimes we need to pump time.
    expect(find.text('START GAME'), findsNothing);
  });
}
