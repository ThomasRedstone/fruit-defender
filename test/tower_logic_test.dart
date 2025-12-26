import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_defender/game/fruit_defender_game.dart';
import 'package:fruit_defender/entities/tower.dart';
import 'package:fruit_defender/main.dart';
import 'package:flame/components.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('New Towers Logic', () {
    final tester = FlameTester(() => FruitDefenderGame(enableHud: false));

    tester.testGameWidget(
      'Berserker should have correct usage stats and no sprite',
      verify: (game, tester) async {
        final tower =
            Tower(position: Vector2.zero(), type: TowerType.BERSERKER);
        await game.ensureAdd(tower);

        expect(tower.range, 80);
        expect(tower.damage, 25);
        expect(tower.fireRate, 0.5);

        // "Make them black dots for now" -> Sprite should be null
        expect(tower.sprite, isNull);
      },
    );

    tester.testGameWidget(
      'Missile should have correct usage stats and no sprite',
      verify: (game, tester) async {
        final tower = Tower(position: Vector2.zero(), type: TowerType.MISSILE);
        await game.ensureAdd(tower);

        expect(tower.range, 250);
        expect(tower.damage, 40);
        expect(tower.fireRate, 2.5);

        // "Make them black dots for now" -> Sprite should be null
        expect(tower.sprite, isNull);
      },
    );
  });
}
