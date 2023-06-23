import 'package:bonfire/bonfire.dart';
import 'package:Openedu.IA/widgets/custom_world_widgets/custom_challenges_widgets/custom_pacman_challenge_widgets/custom_pacman_challenge_widgets.dart';

import '../../../../screens/worlds/challenges_worlds/challenges_world_01/pacman_game_world_01/pacman_homescreen.dart';

class EatScore extends GameDecoration with Movement, Acceleration {
  EatScore({
    required super.position,
  }) : super.withSprite(
          size: Vector2.all(PacManWorld1HomeScreen.tileSize),
          sprite: UtilSpriteSheet.score100,
        ) {
    speed = 140;
    aboveComponents = true;
  }

  @override
  void update(double dt) {
    if (speed == 0 && !isRemoving) {
      removeFromParent();
    }
    super.update(dt);
  }

  @override
  void onMount() {
    applyAccelerationByDirection(-4, Direction.up, stopWhenSpeedZero: true);
    super.onMount();
  }
}
