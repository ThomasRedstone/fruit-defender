import 'dart:ui';
import 'package:flutter/foundation.dart';
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
  final ValueNotifier<TowerType> selectedTowerNotifier =
      ValueNotifier(TowerType.WIZARD);
  TowerType get selectedTower => selectedTowerNotifier.value;
  set selectedTower(TowerType type) => selectedTowerNotifier.value = type;
  final bool enableHud;
  final bool useGoogleFontsInHud;
  double timeScale = 1.0;

  FruitDefenderGame({this.enableHud = true, this.useGoogleFontsInHud = true});

  bool isGameStarted = false;
  late WaveManager waveManager;

  @override
  Future<void> onLoad() async {
    levelMap = LevelMap();
    add(levelMap);

    // Base at the end of the path
    final basePosition = levelMap.waypoints.last.clone();
    add(Base(basePosition));

    // Wave Manager
    waveManager = WaveManager();
    add(waveManager);

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
    // Clear entities (use descendants to catch nested entities in World)
    descendants()
        .whereType<Enemy>()
        .toList()
        .forEach((e) => e.removeFromParent());
    descendants()
        .whereType<Tower>()
        .toList()
        .forEach((t) => t.removeFromParent());
    descendants()
        .whereType<Projectile>()
        .toList()
        .forEach((p) => p.removeFromParent());

    // Reset Wave
    waveManager.currentWave = 1;
    waveManager.enemiesSpawned = 0;
    waveManager.spawnTimer = 0;
    waveManager.enemiesSpawned = 0;
    waveManager.spawnTimer = 0;

    overlays.remove('GameOver');
    resumeEngine();
  }

  @override
  void onTapDown(TapDownEvent event) {
    handleTap(event.localPosition);
  }

  void handleTap(Vector2 position) {
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
      // Use children for direct access
      for (final child in children.whereType<Tower>()) {
        if (child.position.distanceTo(position) < 40) {
          // Assume 40px radius/size
          canPlace = false;
          break;
        }
      }

      print('Checking collision: Money=$money Cost=$cost');
      // Check collision with path
      if (canPlace) {
        // Iterate path segments
        for (int i = 0; i < levelMap.waypoints.length - 1; i++) {
          final p1 = levelMap.waypoints[i];
          final p2 = levelMap.waypoints[i + 1];
          final d = _getDistanceFromPointToLineSegment(position, p1, p2);

          // 32px threshold
          if (d < 32) {
            print('Collision with path segment $i ($p1 -> $p2) dist=$d');
            canPlace = false;
            break;
          }
        }
      }

      print('CanPlace result: $canPlace');

      if (canPlace) {
        money -= cost;
        final tower = Tower(position: position, type: selectedTower);
        add(tower);
        print('Tower added');
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

  double _getDistanceFromPointToLineSegment(Vector2 p, Vector2 a, Vector2 b) {
    final segment = b - a;
    final lengthSquared = segment.length2;
    if (lengthSquared == 0) return p.distanceTo(a);

    final t =
        ((p.x - a.x) * (b.x - a.x) + (p.y - a.y) * (b.y - a.y)) / lengthSquared;

    // Clamp t to segment range [0, 1]
    final tClamped = t.clamp(0.0, 1.0);

    final closestPoint = a + segment * tClamped;
    return p.distanceTo(closestPoint);
  }
}
