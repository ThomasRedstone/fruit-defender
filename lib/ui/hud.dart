import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/fruit_defender_game.dart';
import '../game/wave_manager.dart';

class Hud extends PositionComponent with HasGameRef<FruitDefenderGame> {
  late TextComponent hudText;

  @override
  Future<void> onLoad() async {
    // Pixel/Blocky Font style
    final textStyle = GoogleFonts.vt323(
      fontSize: 24.0,
      color: const Color(0xFFFFFFFF),
      shadows: [
        const Shadow(
          blurRadius: 2.0,
          color: Color(0xFF000000),
          offset: Offset(2.0, 2.0),
        ),
      ],
    );
    final textRenderer = TextPaint(style: textStyle);

    hudText = TextComponent(
      text: 'Money: \$0  Lives: 20  Wave: 1',
      textRenderer: textRenderer,
      position: Vector2(20, 20), // Added more padding
    );
    add(hudText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final waveManager = gameRef.children.whereType<WaveManager>().firstOrNull;
    final wave = waveManager?.currentWave ?? 1;
    hudText.text =
        'Money: \$${gameRef.money}  Lives: ${gameRef.lives}  Wave: $wave';
  }
}
