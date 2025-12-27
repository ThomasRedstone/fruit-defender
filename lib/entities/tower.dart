import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'enemy.dart';
import 'projectile.dart';
import '../game/fruit_defender_game.dart';

enum TowerType { WIZARD, SNIPER, NINJA, FACTORY, BERSERKER, MISSILE }

class Tower extends PositionComponent with HasGameRef<FruitDefenderGame> {
  Sprite? sprite;
  final TowerType type;
  double range = 200;
  double damage = 10;
  double fireRate = 1.0;
  double _timer = 0;

  Tower({required Vector2 position, this.type = TowerType.WIZARD})
      : super(
            position: position, size: Vector2(32, 64), anchor: Anchor.center) {
    switch (type) {
      case TowerType.SNIPER:
        range = double.infinity;
        damage = 50;
        fireRate = 3.0;
        size = Vector2(32, 64);
        break;
      case TowerType.NINJA:
        range = 150;
        damage = 5;
        fireRate = 0.2;
        size = Vector2(32, 50);
        break;
      case TowerType.FACTORY:
        range = 0;
        damage = 0;
        fireRate = 10.0; // Production rate
        size = Vector2(40, 40);
        break;
      case TowerType.BERSERKER:
        range = 80;
        damage = 25;
        fireRate = 0.5;
        size = Vector2(32, 32);
        break;
      case TowerType.MISSILE:
        range = 250;
        damage = 40;
        fireRate = 2.5;
        size = Vector2(96, 96);
        break;
      case TowerType.WIZARD:
        range = 200;
        damage = 15;
        fireRate = 1.0;
        size = Vector2(32, 64);
        break;
    }
  }

  @override
  Future<void> onLoad() async {
    String? spriteAsset;
    switch (type) {
      case TowerType.WIZARD:
        spriteAsset = 'defender_wizard.png';
        break;
      case TowerType.SNIPER:
        spriteAsset = 'defender_sniper.png';
        break;
      case TowerType.NINJA:
        spriteAsset = 'defender_ninja.png';
        break;
      case TowerType.FACTORY:
        spriteAsset = 'tower_factory.png';
        break;
      case TowerType.BERSERKER:
        spriteAsset = 'defender_berserker.png';
        break;
      case TowerType.MISSILE:
        spriteAsset = 'defender_missile.png';
        break;
      default:
        spriteAsset = null;
        break;
    }

    if (spriteAsset != null) {
      try {
        sprite = await gameRef.loadSprite(spriteAsset);
      } catch (e) {
        print("Could not load sprite $spriteAsset: $e");
      }
    }
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (type == TowerType.FACTORY) {
      _timer += dt;
      if (_timer >= fireRate) {
        _timer = 0;
        gameRef.money += 50;
        // Visual feedback (optional)
        print("Factory Generated \$50");
      }
      return;
    }

    _timer += dt;
    if (_timer >= fireRate) {
      final target = _findTarget();
      if (target != null) {
        _shoot(target);
        _timer = 0;
      }
    }
  }

  Enemy? _findTarget() {
    // Simple: Find closest enemy in range
    Enemy? bestTarget;
    double minDistance = double.infinity;

    for (final child in gameRef.children) {
      if (child is Enemy) {
        final distance = position.distanceTo(child.position);
        if (distance <= range) {
          if (distance < minDistance) {
            minDistance = distance;
            bestTarget = child;
          }
        }
      }
    }
    return bestTarget;
  }

  void _shoot(Enemy target) {
    // Spawn Projectile
    double speed = 600.0;
    double splash = 0.0;

    if (type == TowerType.SNIPER) {
      speed = 2400.0; // 4x speed
    } else if (type == TowerType.MISSILE) {
      speed = 400.0; // Slow missile
      splash = 100.0; // Splash radius
    } else if (type == TowerType.BERSERKER) {
      // Technically melee, but implementing as very short range projectile for now
      speed = 1000.0;
    }

    String? projectileAsset;
    switch (type) {
      case TowerType.WIZARD:
        projectileAsset = 'projectile_orb.png';
        break;
      case TowerType.NINJA:
        projectileAsset = 'projectile_shuriken.png';
        break;
      case TowerType.SNIPER:
        projectileAsset = 'projectile_bullet.png';
        break;
      case TowerType.MISSILE:
        projectileAsset = 'projectile_rocket.png';
        break;
      case TowerType.BERSERKER:
        projectileAsset = 'projectile_fist.png';
        break;
      default:
        projectileAsset = null;
    }

    final projectile = Projectile(
      position: position.clone(),
      target: target,
      damage: damage,
      speed: speed,
      splashRadius: splash,
      spriteAsset: projectileAsset,
    );
    gameRef.add(projectile);
  }

  @override
  void render(Canvas canvas) {
    if (sprite != null) {
      sprite!.render(canvas, position: Vector2.zero(), size: size);
      // No return here if we want to draw debug overlay, but usually we just want the sprite.
      // However, the original code had a return in my previous thought block.
      // Let's stick to: if sprite exists, draw it and exit.
      return;
    }

    // Fallback: Color based on type
    Color color = const Color(0xFF0000FF); // Wizard Blue
    switch (type) {
      case TowerType.SNIPER:
        color = const Color(0xFF444444);
        break;
      case TowerType.NINJA:
        color = const Color(0xFF000000);
        break;
      case TowerType.FACTORY:
        color = const Color(0xFFFFD700); // Gold
        break;
      case TowerType.BERSERKER:
      case TowerType.MISSILE:
        color = const Color(0xFF000000); // Black dots
        break;
      default:
        break;
    }

    // Draw Circle for "Black Dots" requested style (or rect for others)
    if (type == TowerType.BERSERKER || type == TowerType.MISSILE) {
      canvas.drawCircle(
          Offset(size.x / 2, size.y / 2), size.x / 2, Paint()..color = color);
    } else {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()..color = color,
      );
    }
  }
}
