import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_defender/game/fruit_defender_game.dart';
import 'package:fruit_defender/entities/tower.dart';
// import 'package:flame/events.dart'; // Removed
// import 'package:flame/components.dart'; // Removed
import 'dart:ui'; // For Image creation

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

  group('Economy Tests', () {
    // Disable HUD to avoid font loading issues in Economy tests
    final tester = FlameTester(() => FruitDefenderGame(enableHud: false));

    tester.testGameWidget(
      'Initial money should be 500',
      verify: (game, tester) async {
        game.startGame();
        await tester.pump();
        expect(game.money, 500);
      },
    );

    tester.testGameWidget(
      'Factory cost regression test',
      verify: (game, tester) async {
        // Mock image for Factory
        final image = await createTestImage();
        game.images.add('tower_factory.png', image);

        // Setup state
        game.money = 500;
        game.selectedTower = TowerType.FACTORY;

        expect(game.money, greaterThanOrEqualTo(400));

        // Use WidgetTester to tap (Simulate clicking map at 100,100)
        await tester.tapAt(const Offset(100, 100));
        await tester.pump();

        // Wait for Pending Timers (GestureRecognizer) to expire
        await tester.pump(const Duration(seconds: 1));

        // Allow game loop to process addition (addLater)
        game.update(0.1);

        // Verify money deducted (500 - 400 = 100)
        expect(game.money, 100);

        // Verify tower added
        expect(game.children.whereType<Tower>().length, 1);
      },
    );
  });
}
