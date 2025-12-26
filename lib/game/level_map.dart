import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LevelMap extends PositionComponent {
  final List<Vector2> waypoints = [
    Vector2(0, 100),
    Vector2(300, 100),
    Vector2(300, 500),
    Vector2(600, 500),
    Vector2(600, 200),
    Vector2(900, 200),
    Vector2(900, 600),
    Vector2(1600, 600), // Extended off-screen
  ];

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = const Color(0xFFD2B48C) // Tan color
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final borderPaint = Paint()
      ..color = const Color(0xFF8B4513) // Brown border
      ..strokeWidth = 44
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (waypoints.isNotEmpty) {
      path.moveTo(waypoints.first.x, waypoints.first.y);
      for (int i = 1; i < waypoints.length; i++) {
        path.lineTo(waypoints[i].x, waypoints[i].y);
      }
    }

    canvas.drawPath(path, borderPaint);
    canvas.drawPath(path, paint);
  }
}
