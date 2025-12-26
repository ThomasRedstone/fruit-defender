import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_defender/game/fruit_defender_game.dart';
import 'package:fruit_defender/ui/hud.dart';
import 'package:fruit_defender/game/wave_manager.dart';

import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('HUD Tests', () {
    // Disable Google Fonts for tests
    testWithGame<FruitDefenderGame>('HUD updates text correctly',
        () => FruitDefenderGame(useGoogleFontsInHud: false), (game) async {
      // Find HUD
      final hud = game.children.whereType<Hud>().first;

      // Initial state verify (Money 500, Lives 20, Wave 1)
      game.update(0); // Trigger update
      expect(hud.hudText.text, contains('Money: \$500'));
      expect(hud.hudText.text, contains('Lives: 20'));
      expect(hud.hudText.text, contains('Wave: 1'));

      // Modify game state
      game.money = 1000;
      game.lives = 10;

      // Find WaveManager and update wave
      final waveManager = game.children.whereType<WaveManager>().first;
      waveManager.currentWave = 5;

      // Update game loop
      game.update(0.1);

      // Verify HUD text update
      expect(hud.hudText.text, contains('Money: \$1000'));
      expect(hud.hudText.text, contains('Lives: 10'));
      expect(hud.hudText.text, contains('Wave: 5'));
    });
  });
}
