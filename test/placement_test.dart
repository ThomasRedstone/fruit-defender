import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_defender/game/fruit_defender_game.dart';
import 'package:fruit_defender/entities/tower.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' hide Image; // Fix type conflict
import 'dart:ui'; // For Image mock

import 'package:google_fonts/google_fonts.dart';

Future<Image> createTestImage() async {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(const Rect.fromLTWH(0, 0, 1, 1), Paint());
  final picture = recorder.endRecording();
  return picture.toImage(1, 1);
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Placement Tests', () {
    final tester = FlameTester(() => FruitDefenderGame(enableHud: false));

    tester.testGameWidget(
      'Should not place tower on top of another tower',
      verify: (game, tester) async {
        // Setup
        final image = await createTestImage();
        game.images.add('defender_wizard.png', image);
        game.images.add('tower_factory.png', image);

        game.money = 1000;
        game.selectedTower = TowerType.WIZARD; // Cost 100

        // Place first tower at 100,100
        await tester.tapAt(const Offset(100, 100));
        await tester.pump();
        game.update(0.1);

        expect(game.children.whereType<Tower>().length, 1);
        expect(game.money, 900);

        // Try place second tower at same spot (collision)
        await tester.tapAt(const Offset(100, 100));
        await tester.pump();

        // Clear timers
        await tester.pump(const Duration(seconds: 1));

        // Clear timers
        await tester.pump(const Duration(seconds: 1));

        game.update(0.1);

        // Should FAIL to add tower, Money should NOT decrease
        expect(game.children.whereType<Tower>().length, 1);
        expect(game.money, 900);
      },
    );
  });
}
