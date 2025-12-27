import 'dart:ui';
import 'package:flame/components.dart';
import 'enemy.dart';
import '../game/fruit_defender_game.dart';

import 'dart:math';

class Projectile extends PositionComponent with HasGameRef<FruitDefenderGame> {
  final Enemy target;
  final double damage;
  final double speed;
  final double splashRadius;
  final String? spriteAsset;
  Sprite? sprite;

  Projectile({
    required Vector2 position,
    required this.target,
    required this.damage,
    this.speed = 600.0,
    this.splashRadius = 0.0,
    this.spriteAsset,
  }) : super(position: position, size: Vector2(24, 24), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    if (spriteAsset != null) {
      try {
        sprite = await gameRef.loadSprite(spriteAsset!);
      } catch (e) {
        print('Error loading projectile sprite: $e');
      }
    }
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (target.isRemoved) {
      removeFromParent();
      return;
    }

    final diff = target.position - position;

    // Rotate to face target
    angle = atan2(diff.y, diff.x);

    if (diff.length < speed * dt) {
      // Hit
      if (splashRadius > 0) {
        // AOE Damage
        final enemies = gameRef.children.whereType<Enemy>().toList();
        for (final child in enemies) {
          if (!child.isRemoved) {
            if (child.position.distanceTo(target.position) <= splashRadius) {
              child.takeDamage(damage);
            }
          }
        }
      } else {
        // Single Target
        target.takeDamage(damage);
      }
      removeFromParent();
    } else {
      position += diff.normalized() * speed * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    if (sprite != null) {
      sprite!.render(canvas, position: Vector2.zero(), size: size);
    } else {
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        size.x / 2,
        Paint()..color = const Color(0xFFFFFF00),
      );
    }
  }
}
