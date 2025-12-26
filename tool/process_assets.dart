import 'dart:io';
import 'package:image/image.dart';

void main() async {
  final dir = Directory('assets/images');
  if (!await dir.exists()) {
    print('Assets directory not found');
    return;
  }

  await for (final file in dir.list()) {
    if (file is File && file.path.endsWith('.png')) {
      print('Processing ${file.path}...');
      final bytes = await file.readAsBytes();
      Image? image = decodePng(bytes);

      if (image == null) continue;

      print('  Inspecting ${file.path}...');
      final topLeft = image.getPixel(0, 0);
      print(
          '  Top-Left Pixel: R${topLeft.r} G${topLeft.g} B${topLeft.b} A${topLeft.a}');

      // Aggressive Clean: Flood Fill from all 4 corners
      // Target: Anything that matches the corner color within tolerance
      // Replacement: Transparent

      final corners = [
        Point(0, 0),
        Point(image.width - 1, 0),
        Point(0, image.height - 1),
        Point(image.width - 1, image.height - 1)
      ];

      for (final start in corners) {
        final startColor = image.getPixel(start.x.toInt(), start.y.toInt());
        if (startColor.a == 0) continue; // Already transparent

        print('  Flood filling from $start (Color: ${startColor})...');

        final queue = <Point>[Point(start.x.toInt(), start.y.toInt())];
        final visited = <Point>{};

        while (queue.isNotEmpty) {
          final p = queue.removeLast();
          if (visited.contains(p)) continue;
          visited.add(p);

          if (p.x < 0 || p.x >= image.width || p.y < 0 || p.y >= image.height)
            continue;

          final pixel = image.getPixel(p.x.toInt(), p.y.toInt());
          // Tolerance check against start color
          int diff = (pixel.r - startColor.r).abs().toInt() +
              (pixel.g - startColor.g).abs().toInt() +
              (pixel.b - startColor.b).abs().toInt();

          if (diff < 50) {
            // Tolerance
            pixel.r = 0;
            pixel.g = 0;
            pixel.b = 0;
            pixel.a = 0;

            queue.add(Point(p.x + 1, p.y));
            queue.add(Point(p.x - 1, p.y));
            queue.add(Point(p.x, p.y + 1));
            queue.add(Point(p.x, p.y - 1));
          }
        }
      }

      // 2. Trim Whitespace (Auto-crop)
      image = findTrim(image);

      // Save
      await file.writeAsBytes(encodePng(image));
      print('  Saved.');
    }
  }
}

// Helper to calculate color distance
num distance(Pixel p1, Pixel p2) {
  return (p1.r - p2.r).abs() + (p1.g - p2.g).abs() + (p1.b - p2.b).abs();
}

Image findTrim(Image src) {
  int minX = src.width;
  int minY = src.height;
  int maxX = 0;
  int maxY = 0;

  bool found = false;

  for (var y = 0; y < src.height; y++) {
    for (var x = 0; x < src.width; x++) {
      final p = src.getPixel(x, y);
      if (p.a > 0) {
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
        found = true;
      }
    }
  }

  if (!found) return src; // Empty image

  // Add 1px padding if desired, or just crop exactly
  return copyCrop(src,
      x: minX, y: minY, width: maxX - minX + 1, height: maxY - minY + 1);
}
