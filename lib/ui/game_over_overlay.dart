import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/fruit_defender_game.dart';

class GameOverOverlay extends StatelessWidget {
  final FruitDefenderGame game;

  const GameOverOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red, width: 4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GAME OVER',
              style: GoogleFonts.vt323(
                fontSize: 64,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                game.restartGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                'TRY AGAIN',
                style: GoogleFonts.vt323(fontSize: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
