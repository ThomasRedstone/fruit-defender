import 'dart:ui';
import 'package:flame/components.dart';
import 'enemy.dart';

class Projectile extends PositionComponent {
  final Enemy target;
  final double damage;
  final double speed;

  Projectile({
    required Vector2 position,
    required this.target,
    required this.damage,
    this.speed = 600.0,
  }) : super(position: position, size: Vector2(10, 10), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);

    // If target is dead, keep moving to last known pos?
    // For now, let's just let it disappear if target dies, as original.
    // The issue "disappear before reach" is likely speed or target death.
    // User asked for speed increase.

    if (target.isRemoved) {
      removeFromParent();
      return;
    }

    final diff = target.position - position;
    if (diff.length < speed * dt) {
      // Hit
      target.takeDamage(damage);
      removeFromParent();
    } else {
      position += diff.normalized() * speed * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      size.x / 2,
      Paint()..color = const Color(0xFFFFFF00),
    );
  }
}
