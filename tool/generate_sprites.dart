import 'dart:io';
import 'package:image/image.dart';

void main() async {
  // Define sprites to generate
  final sprites = {
    'defender_ninja.png': ColorUint8.rgb(0, 0, 0), // Black
    'defender_sniper.png': ColorUint8.rgb(34, 139, 34), // Forest Green
    'defender_wizard.png': ColorUint8.rgb(0, 0, 255), // Blue
    'defender_berserker.png': ColorUint8.rgb(139, 0, 0), // Dark Red
    'defender_missile.png': ColorUint8.rgb(80, 80, 80), // Dark Grey
  };

  for (final entry in sprites.entries) {
    final name = entry.key;
    final color = entry.value;

    // Create 32x32 image
    final image = Image(width: 32, height: 32, numChannels: 4);

    // Fill with White (Background)
    image.clear(ColorUint8.rgb(255, 255, 255));

    // Draw Character (Symbolic)
    final centerX = 16;
    final centerY = 16;
    final size = 10;

    // Draw body
    fillRect(image,
        x1: centerX - size ~/ 2,
        y1: centerY - size ~/ 2,
        x2: centerX + size ~/ 2,
        y2: centerY + size ~/ 2,
        color: color);

    // Add some details to distinguish
    if (name.contains('ninja')) {
      // Red headband (rect)
      fillRect(image,
          x1: centerX - size ~/ 2,
          y1: centerY - 4,
          x2: centerX + size ~/ 2,
          y2: centerY - 2,
          color: ColorUint8.rgb(255, 0, 0));
    } else if (name.contains('sniper')) {
      // Gun barrel (line)
      drawLine(image,
          x1: centerX,
          y1: centerY,
          x2: centerX + 10,
          y2: centerY,
          color: ColorUint8.rgb(0, 0, 0));
    } else if (name.contains('wizard')) {
      // Hat (triangle-ish logic or just rect on top)
      fillRect(image,
          x1: centerX - 2,
          y1: centerY - 10,
          x2: centerX + 2,
          y2: centerY - 5,
          color: color);
    } else if (name.contains('berserker')) {
      // Axes (X shape)
      drawLine(image,
          x1: centerX - 4,
          y1: centerY - 4,
          x2: centerX + 4,
          y2: centerY + 4,
          color: ColorUint8.rgb(255, 255, 0));
      drawLine(image,
          x1: centerX + 4,
          y1: centerY - 4,
          x2: centerX - 4,
          y2: centerY + 4,
          color: ColorUint8.rgb(255, 255, 0));
    } else if (name.contains('missile')) {
      // Launcher (Box on top)
      fillRect(image,
          x1: centerX - 4,
          y1: centerY - 8,
          x2: centerX + 4,
          y2: centerY - 4,
          color: ColorUint8.rgb(100, 100, 100));
    }

    // Save
    final path = 'assets/images/$name';
    await File(path).writeAsBytes(encodePng(image));
    print('Generated $path');
  }
}
