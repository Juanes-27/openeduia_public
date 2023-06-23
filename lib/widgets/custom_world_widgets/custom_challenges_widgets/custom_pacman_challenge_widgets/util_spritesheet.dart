import 'package:bonfire/bonfire.dart';
import '../../../../screens/worlds/challenges_worlds/challenges_world_01/pacman_game_world_01/pacman_homescreen.dart';

class UtilSpriteSheet {
  static Future<Sprite> dot = Sprite.load('dot.png');

  static Future<SpriteAnimation> get dotPower => SpriteAnimation.load(
        'dot_power.png',
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.4,
          textureSize: Vector2.all(18),
        ),
      );

  static Future<Sprite> get score100 => Sprite.load('pacman-sprites.png',
      srcSize: Vector2.all(48),
      srcPosition: Vector2(4 * PacManWorld1HomeScreen.tileSize,
          7 * PacManWorld1HomeScreen.tileSize));

  static Future<Sprite> get pacman => Sprite.load('pacman-sprites.png',
      srcSize: Vector2.all(48),
      srcPosition: Vector2(1 * PacManWorld1HomeScreen.tileSize, 0));
}
