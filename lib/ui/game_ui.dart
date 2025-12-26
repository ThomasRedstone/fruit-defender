import 'package:flutter/material.dart';
import '../game/fruit_defender_game.dart';
import '../entities/tower.dart';

import 'package:google_fonts/google_fonts.dart';

class GameUI extends StatelessWidget {
  final FruitDefenderGame game;

  const GameUI({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Game content...
        // Towers
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 160, // Increased from 130 to 160
            color: Colors.black54,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  _buildTowerButton(game, TowerType.WIZARD, 'Wizard', 100,
                      'defender_wizard.png'),
                  const SizedBox(width: 8),
                  _buildTowerButton(game, TowerType.SNIPER, 'Sniper', 300,
                      'defender_sniper.png'),
                  const SizedBox(width: 8),
                  _buildTowerButton(game, TowerType.NINJA, 'Ninja', 200,
                      'defender_ninja.png'),
                  const SizedBox(width: 8),
                  _buildTowerButton(game, TowerType.BERSERKER, 'Berserk', 150,
                      'defender_berserker.png'),
                  const SizedBox(width: 8),
                  _buildTowerButton(game, TowerType.MISSILE, 'Missile', 500,
                      'defender_missile.png'),
                  const SizedBox(width: 8),
                  _buildTowerButton(game, TowerType.FACTORY, 'Merchant', 400,
                      'tower_factory.png'),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),

        // Speed Controls
        Positioned(
          bottom: 150, // Above the taller tower bar
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black54,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSpeedButton(0.25, '0.25x'),
                const SizedBox(width: 8),
                _buildSpeedButton(1.0, '1x'),
                const SizedBox(width: 8),
                _buildSpeedButton(5.0, '5x'),
                const SizedBox(width: 8),
                _buildSpeedButton(10.0, '10x'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedButton(double speed, String label) {
    return GestureDetector(
      onTap: () {
        game.timeScale = speed;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          border: Border.all(color: const Color(0xFFFFFFFF)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: GoogleFonts.vt323(
            color: Colors.white,
            fontSize: 20,
          ),
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
        height: 120, // Increased from 90 to 120
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
