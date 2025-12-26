import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart'; // For TapDownDetails
import 'package:fruit_defender/game/fruit_defender_game.dart';
import 'package:fruit_defender/entities/tower.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';

void main() {
  group('Economy Tests', () {
    testWithGame<FruitDefenderGame>(
        'Initial money should be 500', FruitDefenderGame.new, (game) async {
      expect(game.money, 500);
    });

    testWithGame<FruitDefenderGame>(
        'Factory cost regression test', FruitDefenderGame.new, (game) async {
      // Setup
      game.money = 500;
      game.selectedTower = TowerType.FACTORY;

      expect(game.money, greaterThanOrEqualTo(400),
          reason: "Starting money must check afford Factory");

      // Simulate tap to buy Factory (Cost 400)
      // TapDownEvent(int pointerId, Game game, TapDownDetails details)
      game.onTapDown(TapDownEvent(
        1,
        game,
        TapDownDetails(
          kind: null,
          globalPosition: Offset.zero,
          localPosition: Offset.zero,
        ),
      ));

      // Verification:
      expect(game.money, 100); // 500 - 400
      expect(game.children.whereType<Tower>().length, 1);
    });
  });
}
