import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import '../game/fruit_defender_game.dart';

class Enemy extends PositionComponent with HasGameRef<FruitDefenderGame> {
  final List<Vector2> waypoints;
  final double speed = 100.0;
  double health = 40.0;
  int currentWaypointIndex = 0;
  Sprite? sprite;
  final bool skipSprite;

  Enemy(this.waypoints, {this.skipSprite = false})
      : super(size: Vector2(32, 32)) {
    // Start at first waypoint
    if (waypoints.isNotEmpty) {
      position = waypoints[0];
    }
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    if (!skipSprite) {
      try {
        sprite = await gameRef.loadSprite('enemy_apple.png');
      } catch (e) {
        print('Enemy sprite load failed: $e');
      }
    }
    await super.onLoad();
    _moveToNextWaypoint();
  }

  @override
  void render(Canvas canvas) {
    if (sprite != null) {
      sprite!.render(canvas, position: Vector2.zero(), size: size);
      return;
    }
    // Fallback render
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2,
        Paint()..color = const Color(0xFFFF0000));
  }

  void _moveToNextWaypoint() {
    if (currentWaypointIndex >= waypoints.length - 1) {
      removeFromParent(); // Reached end
      gameRef.lives -= 1;
      gameRef.checkGameOver();
      return;
    }

    final nextPoint = waypoints[currentWaypointIndex + 1];
    final distance = position.distanceTo(nextPoint);
    final duration = distance / speed;
    print('Distance: $distance, Duration: $duration');

    add(
      MoveToEffect(
        nextPoint,
        EffectController(duration: duration),
        onComplete: () {
          print('Move complete');
          currentWaypointIndex++;
          _moveToNextWaypoint();
        },
      ),
    );
  }

  // Render handled by SpriteComponent

  void takeDamage(double amount) {
    health -= amount;
    if (health <= 0) {
      removeFromParent();
      // Access gameRef via lookup or mixin
      _awardMoney();
    }
  }

  void _awardMoney() {
    gameRef.money += 10;
  }
}
