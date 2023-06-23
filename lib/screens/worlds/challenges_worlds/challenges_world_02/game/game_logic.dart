import 'package:flutter/material.dart';

class GameLogic {
  final String hiddenCard =
      'assets/challenges_assets/memory_challenge/hidden.jpg';
  List<String>? cardsImg;
  String level = '';

  late List<String> card_list = [];

  var axiCount = 0;
  var cardCount = 0;
  List<Map<int, String>> matchCheck = [];

  void initGame(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    String difficult = arguments['level'] as String;
    if (difficult == 'medium') {
      cardCount = 24;
      axiCount = 6;
      card_list = [
        'assets/challenges_assets/memory_challenge/developer.jpg',
        'assets/challenges_assets/memory_challenge/gamer.jpg',
        'assets/challenges_assets/memory_challenge/developer.jpg',
        'assets/challenges_assets/memory_challenge/snake.png',
        'assets/challenges_assets/memory_challenge/game-console.png',
        'assets/challenges_assets/memory_challenge/developer.jpg',
        'assets/challenges_assets/memory_challenge/developer.jpg',
        'assets/challenges_assets/memory_challenge/gamepad.png',
        'assets/challenges_assets/memory_challenge/snake.png',
        'assets/challenges_assets/memory_challenge/game-console.png',
        'assets/challenges_assets/memory_challenge/game-pad.png',
        'assets/challenges_assets/memory_challenge/game-pad.png',
        'assets/challenges_assets/memory_challenge/snake.png',
        'assets/challenges_assets/memory_challenge/snake.png',
        'assets/challenges_assets/memory_challenge/gamepad.png',
        'assets/challenges_assets/memory_challenge/tetris.png',
        'assets/challenges_assets/memory_challenge/tetris.png',
        'assets/challenges_assets/memory_challenge/pick.png',
        'assets/challenges_assets/memory_challenge/pick.png',
        'assets/challenges_assets/memory_challenge/gamer.jpg',
        'assets/challenges_assets/memory_challenge/pixel.png',
        'assets/challenges_assets/memory_challenge/pixel.png',
        'assets/challenges_assets/memory_challenge/learning.jpg',
        'assets/challenges_assets/memory_challenge/learning.jpg',
      ];
    }
    card_list.shuffle();
    cardsImg = List<String>.generate(cardCount, (index) {
      return hiddenCard;
    });
  }
}
