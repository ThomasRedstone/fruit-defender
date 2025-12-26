import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import '../game/fruit_defender_game.dart';

class Enemy extends SpriteComponent with HasGameRef<FruitDefenderGame> {
  final List<Vector2> waypoints;
  final double speed = 100.0;
  double health = 40.0;
  int currentWaypointIndex = 0;

  Enemy(this.waypoints) : super(size: Vector2(32, 32)) {
    // Start at first waypoint
    if (waypoints.isNotEmpty) {
      position = waypoints[0];
    }
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('enemy_apple.png');
    await super.onLoad();
    _moveToNextWaypoint();
  }

  void _moveToNextWaypoint() {
    if (currentWaypointIndex >= waypoints.length - 1) {
      removeFromParent(); // Reached end
      gameRef.lives -= 1;
      if (gameRef.lives <= 0) {
        print("GAME OVER");
        gameRef.pauseEngine();
      }
      return;
    }

    final nextPoint = waypoints[currentWaypointIndex + 1];
    final distance = position.distanceTo(nextPoint);
    final duration = distance / speed;

    add(
      MoveToEffect(
        nextPoint,
        EffectController(duration: duration),
        onComplete: () {
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
