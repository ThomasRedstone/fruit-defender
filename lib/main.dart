import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/fruit_defender_game.dart';
import 'ui/game_ui.dart';
import 'ui/game_over_overlay.dart';
import 'ui/start_screen.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget<FruitDefenderGame>.controlled(
          gameFactory: FruitDefenderGame.new,
          overlayBuilderMap: {
            'GameUI': (BuildContext context, FruitDefenderGame game) {
              return GameUI(game: game);
            },
            'GameOver': (BuildContext context, FruitDefenderGame game) {
              return GameOverOverlay(game: game);
            },
            'StartScreen': (BuildContext context, FruitDefenderGame game) {
              return StartScreen(game: game);
            },
          },
          initialActiveOverlays: const ['GameUI'],
        ),
      ),
    ),
  );
}
