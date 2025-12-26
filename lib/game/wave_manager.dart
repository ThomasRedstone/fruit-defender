import 'package:flame/components.dart';
import 'fruit_defender_game.dart';
import '../entities/enemy.dart';

class WaveManager extends Component with HasGameRef<FruitDefenderGame> {
  double spawnTimer = 0;
  double spawnInterval = 2.0; // Seconds between enemies
  int enemiesSpawned = 0;
  int currentWave = 1;

  @override
  void update(double dt) {
    super.update(dt);

    // Wave Logic
    int enemiesPerWave = 5 * currentWave;

    if (enemiesSpawned < enemiesPerWave) {
      spawnTimer += dt;
      if (spawnTimer >= spawnInterval) {
        spawnTimer = 0;
        spawnEnemy();
      }
    } else {
      // All enemies for this wave have been spawned.
      // Check if any are still alive.
      bool anyEnemiesAlive = gameRef.children.whereType<Enemy>().isNotEmpty;

      if (!anyEnemiesAlive) {
        currentWave++;
        enemiesSpawned = 0;
        // Optionally wait a bit before starting next wave?
        spawnTimer = -2.0; // delay next wave by 2 seconds
      }
    }
  }

  void spawnEnemy() {
    // TODO: Different enemy types based on wave
    final enemy = Enemy(gameRef.levelMap.waypoints);
    gameRef.add(enemy);
    enemiesSpawned++;
  }
}
