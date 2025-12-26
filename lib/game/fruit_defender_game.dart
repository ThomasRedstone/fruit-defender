import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import '../entities/tower.dart';
import '../entities/base.dart';
import 'level_map.dart';
import 'wave_manager.dart';
import '../ui/hud.dart';

class FruitDefenderGame extends FlameGame with TapCallbacks {
  late LevelMap levelMap;
  int money = 500;
  int lives = 20;
  TowerType selectedTower = TowerType.WIZARD;

  @override
  Future<void> onLoad() async {
    levelMap = LevelMap();
    add(levelMap);

    // Base at the end of the path
    final basePosition = levelMap.waypoints.last.clone();
    // Adjust to be safely on screen if needed, or just allow offscreen if map is large
    // Since we extended to 1600 and view might be smaller, we should ensure scaling or camera
    // But for now let's just place it.
    add(Base(basePosition));

    // Wave Manager
    add(WaveManager());

    // HUD
    add(Hud());
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
      case TowerType.FACTORY:
        cost = 400;
        break;
      case TowerType.WIZARD:
      default:
        cost = 100;
        break;
    }

    if (money >= cost) {
      money -= cost;
      final tower = Tower(position: event.localPosition, type: selectedTower);
      add(tower);
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
