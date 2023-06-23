import 'package:bonfire/bonfire.dart';
import 'package:Openedu.IA/widgets/custom_world_widgets/custom_challenges_widgets/custom_pacman_challenge_widgets/custom_pacman_challenge_widgets.dart';

class Dot extends GameDecoration {
  bool eated = false;
  Dot({
    required super.position,
  }) : super.withSprite(
          sprite: UtilSpriteSheet.dot,
          size: Vector2.all(12),
        );

  @override
  int get priority => LayerPriority.MAP + 1;
}
