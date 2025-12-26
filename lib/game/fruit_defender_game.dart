import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import '../entities/tower.dart';
import '../entities/projectile.dart'; // Added
import '../entities/enemy.dart'; // Added
import '../entities/base.dart';
import 'level_map.dart';
import 'wave_manager.dart';
import '../ui/hud.dart';

class FruitDefenderGame extends FlameGame with TapCallbacks {
  late LevelMap levelMap;
  int money = 500;
  int lives = 20;
  TowerType selectedTower = TowerType.WIZARD;
  final bool enableHud;
  final bool useGoogleFontsInHud;
  double timeScale = 1.0;

  FruitDefenderGame({this.enableHud = true, this.useGoogleFontsInHud = true});

  bool isGameStarted = false;

  @override
  Future<void> onLoad() async {
    levelMap = LevelMap();
    add(levelMap);

    // Base at the end of the path
    final basePosition = levelMap.waypoints.last.clone();
    add(Base(basePosition));

    // Wave Manager
    add(WaveManager());

    // HUD
    if (enableHud) {
      add(Hud(useGoogleFonts: useGoogleFontsInHud));
    }

    // Initial State: Paused waiting for Start
    pauseEngine();
    overlays.add('StartScreen');
  }

  void startGame() {
    isGameStarted = true;
    overlays.remove('StartScreen');
    resumeEngine();
  }

  @override
  void update(double dt) {
    if (isGameOver) return;
    super.update(dt * timeScale);
  }

  bool isGameOver = false;

  void checkGameOver() {
    if (lives <= 0) {
      isGameOver = true;
      pauseEngine();
      overlays.add('GameOver');
    }
  }

  void restartGame() {
    isGameOver = false;
    lives = 20;
    money = 500;

    // Clear entities
    children.whereType<Enemy>().forEach((e) => e.removeFromParent());
    children.whereType<Tower>().forEach((t) => t.removeFromParent());
    children.whereType<Projectile>().forEach((p) => p.removeFromParent());

    // Reset Wave
    final waveManager = children.whereType<WaveManager>().first;
    waveManager.currentWave = 1;
    waveManager.enemiesSpawned = 0;
    waveManager.spawnTimer = 0;

    overlays.remove('GameOver');
    resumeEngine();
  }

  @override
  void onTapDown(TapDownEvent event) {
    int cost = 100;
    switch (selectedTower) {
      case TowerType.SNIPER:
        cost = 300;
        break;
      case TowerType.NINJA:
        cost = 200;
        break;
      case TowerType.BERSERKER:
        cost = 150;
        break;
      case TowerType.MISSILE:
        cost = 500;
        break;
      case TowerType.FACTORY:
        cost = 400;
        break;
      case TowerType.WIZARD:
      default:
        cost = 100;
        break;
    }

    if (money >= cost) {
      // Check collision
      bool canPlace = true;

      // Check collision with other towers
      for (final child in children.whereType<Tower>()) {
        if (child.position.distanceTo(event.localPosition) < 40) {
          // Assume 40px radius/size
          canPlace = false;
          break;
        }
      }

      // Check collision with path
      if (canPlace) {
        // Iterate waypoints
        for (int i = 0; i < levelMap.waypoints.length - 1; i++) {
          final p1 = levelMap.waypoints[i];
          // Hack: Check distance to waypoints. Ideally upgrade later.
          if (p1.distanceTo(event.localPosition) < 32) {
            canPlace = false;
          }
        }
        // Also check last waypoint (base)
        if (levelMap.waypoints.last.distanceTo(event.localPosition) < 32) {
          canPlace = false;
        }
      }

      if (canPlace) {
        money -= cost;
        final tower = Tower(position: event.localPosition, type: selectedTower);
        add(tower);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Fill background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF44AA44), // Grass green
    );
    super.render(canvas);
  }
}
