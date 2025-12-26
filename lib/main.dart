import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/fruit_defender_game.dart';
import 'ui/game_ui.dart';

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
          },
          initialActiveOverlays: const ['GameUI'],
        ),
      ),
    ),
  );
}
