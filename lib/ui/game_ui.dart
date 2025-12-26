import 'package:flutter/material.dart';
import '../game/fruit_defender_game.dart';
import '../entities/tower.dart';

import 'package:google_fonts/google_fonts.dart';

class GameUI extends StatelessWidget {
  final FruitDefenderGame game;

  const GameUI({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 100,
        color: Colors.black54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTowerButton(
                game, TowerType.WIZARD, 'Wizard', 100, 'defender_wizard.png'),
            _buildTowerButton(
                game, TowerType.SNIPER, 'Sniper', 300, 'defender_sniper.png'),
            _buildTowerButton(
                game, TowerType.NINJA, 'Ninja', 200, 'defender_ninja.png'),
            _buildTowerButton(
                game, TowerType.FACTORY, 'Merchant', 400, 'tower_factory.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildTowerButton(FruitDefenderGame game, TowerType type, String label,
      int cost, String assetName) {
    // Determine if affordable
    final canAfford = game.money >= cost;
    final isSelected = game.selectedTower == type;

    return GestureDetector(
      onTap: () {
        if (canAfford) {
          game.selectedTower = type;
        }
      },
      child: Container(
        width: 80,
        height: 90,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green.withOpacity(0.5)
              : Colors.black.withOpacity(0.5),
          border: Border.all(
              color: canAfford ? Colors.white : Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sprite Preview
            Image.asset(
              'assets/images/$assetName',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none, // Pixel art style
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.vt323(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '\$$cost',
              style: GoogleFonts.vt323(
                  color: canAfford ? Colors.yellow : Colors.red, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
