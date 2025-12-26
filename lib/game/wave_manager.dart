import 'package:flame/components.dart';
import 'fruit_defender_game.dart';
import '../entities/enemy.dart';

class WaveManager extends Component with HasGameRef<FruitDefenderGame> {
  double spawnTimer = 0;
  double spawnInterval = 2.0;
  int enemiesSpawned = 0;
  int currentWave = 1;

  @override
  void update(double dt) {
    super.update(dt);
    spawnTimer += dt;
    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0;
      spawnEnemy();
    }
  }

  void spawnEnemy() {
    // TODO: Different enemy types based on wave
    final enemy = Enemy(gameRef.levelMap.waypoints);
    gameRef.add(enemy);
    enemiesSpawned++;
  }
}
