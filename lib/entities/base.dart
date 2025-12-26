import 'dart:ui';
import 'package:flame/components.dart';

class Base extends PositionComponent {
  Base(Vector2 position) : super(position: position, size: Vector2(60, 60), anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw Base (Blue Square for now, placeholder for Sprite)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF0000FF),
    );
    
    // Draw "HP" text or symbol
    final border = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), border);
  }
}
