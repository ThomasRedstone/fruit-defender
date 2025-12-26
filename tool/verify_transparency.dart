import 'dart:io';
import 'package:image/image.dart';

void main() async {
  final files = [
    'assets/images/tower_factory.png',
    'assets/images/enemy_apple.png',
    'assets/images/defender_wizard.png'
  ];

  for (final path in files) {
    final file = File(path);
    if (!file.existsSync()) {
      print('File not found: $path');
      continue;
    }

    final bytes = await file.readAsBytes();
    final image = decodeImage(bytes);

    if (image == null) {
      print('Could not decode $path');
      continue;
    }

    final tl = image.getPixel(0, 0);
    print('$path Top-Left: R${tl.r} G${tl.g} B${tl.b} A${tl.a}');

    // Check center pixel just in case
    final center = image.getPixel(image.width ~/ 2, image.height ~/ 2);
    print('$path Center: R${center.r} G${center.g} B${center.b} A${center.a}');

    if (tl.a != 0) {
      print('WARNING: Top-left pixel is NOT transparent!');
    } else {
      print('OK: Top-left pixel is transparent.');
    }
    print('---');
  }
}
