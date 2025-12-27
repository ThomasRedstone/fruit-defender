import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_defender/game/fruit_defender_game.dart';
import 'package:fruit_defender/entities/tower.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  group('Placement Tests', () {
    setUpAll(() {
      GoogleFonts.config.allowRuntimeFetching = false;
    });

    testWidgets('Should not place tower on top of another tower',
        (tester) async {
      final game =
          FruitDefenderGame(enableHud: false, useGoogleFontsInHud: false);

      await tester.pumpWidget(
        GameWidget(
          game: game,
          overlayBuilderMap: {
            'StartScreen': (context, game) => const SizedBox(),
            'GameOver': (context, game) => const SizedBox(),
          },
        ),
      );

      game.startGame();
      await tester.pump();

      // Place first tower
      game.money = 1000;
      game.selectedTower = TowerType.BERSERKER;
      game.handleTap(Vector2(200, 200));
      // Process addition (async pump)
      game.update(0.1); // Force add
      await tester.pump(const Duration(seconds: 1));

      // Verify logic execution via money (Indirect verification due to lifecycle test issues)
      // 1000 -      // 1000 - 150 = 850
      expect(game.money, 850);

      // Attempt to place second tower on top
      game.handleTap(Vector2(200, 200));
      game.update(0.1); // Force updates
      await tester.pump(const Duration(seconds: 1));

      // Should fail: Money remains 850
      expect(game.money, 850);
    });

    testWidgets('Berserker Placement does not crash (Regression)',
        (tester) async {
      final game =
          FruitDefenderGame(enableHud: false, useGoogleFontsInHud: false);

      await tester.pumpWidget(
        GameWidget(
          game: game,
          overlayBuilderMap: {
            'StartScreen': (context, game) => const SizedBox(),
            'GameOver': (context, game) => const SizedBox(),
          },
        ),
      );

      game.startGame();
      await tester.pump(); // Ensure mounted

      game.money = 1000;
      game.selectedTower = TowerType.BERSERKER;
      game.handleTap(Vector2(400, 300));
      game.update(0);

      // 1000 - 150 = 850
      expect(game.money, 850);

      // Render frame to ensure no crash
      game.render(Canvas(PictureRecorder())); // Dummy render
    });

    testWidgets('Should not place tower on path segment', (tester) async {
      final game =
          FruitDefenderGame(enableHud: false, useGoogleFontsInHud: false);
      await tester.pumpWidget(
        GameWidget(
          game: game,
          overlayBuilderMap: {
            'StartScreen': (context, game) => const SizedBox(),
            'GameOver': (context, game) => const SizedBox(),
          },
        ),
      );
      game.startGame();
      await tester.pump();

      game.money = 1000;
      game.selectedTower = TowerType.BERSERKER;

      // Waypoints: (0, 100) -> (300, 100)
      // Place exactly on the path segment (150, 100)
      final onPathPos = Vector2(150, 100);
      game.handleTap(onPathPos);
      await tester.pump(const Duration(seconds: 1));

      // Should fail: Money remains 1000
      expect(game.money, 1000,
          reason: "Money should not decrease when placing on path");

      // Try placing far from path (150, 200) - 100px away from the segment
      final offPathPos = Vector2(150, 200);
      game.handleTap(offPathPos);
      await tester.pump(const Duration(seconds: 1));

      // Should succeed: Money decreases (1000 - 150 = 850)
      expect(game.money, 850,
          reason: "Money should decrease when placing off path");
    });
  });
}
