import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_defender/game/fruit_defender_game.dart';
import 'package:fruit_defender/game/wave_manager.dart';

void main() {
  setUpAll(() {
    // Disable Google Fonts runtime fetching
  });

  group('Wave Tests', () {
    // Disable HUD for these tests to avoid font issues
    final tester = FlameTester(() => FruitDefenderGame(enableHud: false));

    tester.testGameWidget(
      'Wave should increment after enemies act',
      verify: (game, tester) async {
        final waveManager = game.children.whereType<WaveManager>().first;
        expect(waveManager.currentWave, 1);

        // Simulate time passing (lots of time)
        // Currently logic just spawns endlessly.
        // We expect wave to change eventually.
        // If the bug exists (it does), this might loop 1 forever.
        // Let's set the waveManager state manually or check its logic.

        // Ideally: Spawn 5 enemies -> Wait for them to die -> Wave 2.
        // Current logic: spawnTimer loops forever.

        // We will assert that after X updates, wave stays 1 (reproduction)
        // OR we implement the test expecting the CORRECT behavior and fail.
        // We want TDD: write test for "After clearing wave 1, wave becomes 2".

        // This requires implementing the logic first? No, fail first.
        // But we need a way to 'finish' a wave.
        // Let's assume a wave has 5 enemies.

        // We can't test "wait for wave 2" if the code has NO Concept of finishing wave 1.
        // But we can assert "wave should be 1 initially" and "should be 2 after condition".

        // Let's write the test forcing the condition we WANT.
        // "Finish Wave" function? Or just killing enemies?
        // Since we know logic is missing, let's just write a test that checks if wave increments.
        // But without logic to increment, it will fail. Good.

        // Simulate game loop: 50 seconds at 0.1s increments (500 steps)
        // Enough time for 5 enemies to spawn (10s) and travel/die (~20s)
        for (int i = 0; i < 1000; i++) {
          game.update(0.1);
        }

        // The user says "remaining at 1".
        // Now it should be > 1
        expect(waveManager.currentWave, greaterThan(1));
      },
    );
  });
}
