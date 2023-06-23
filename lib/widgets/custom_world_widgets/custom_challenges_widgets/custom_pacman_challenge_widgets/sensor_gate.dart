import 'package:bonfire/bonfire.dart';
import '../../../../screens/worlds/challenges_worlds/challenges_world_01/pacman_game_world_01/pacman_homescreen.dart';

enum DiractionGate { left, right }

class SensorGate extends GameDecoration with Sensor {
  bool canMove = true;
  final DiractionGate direction;
  SensorGate({required super.position, this.direction = DiractionGate.left})
      : super(size: Vector2.all(PacManWorld1HomeScreen.tileSize));

  @override
  void onContact(GameComponent component) {
    if (canMove) {
      canMove = false;
      switch (direction) {
        case DiractionGate.left:
          component.position = component.position.copyWith(
            x: 18 * PacManWorld1HomeScreen.tileSize,
          );
          break;
        case DiractionGate.right:
          component.position = component.position.copyWith(
            x: 0,
          );
          break;
      }
    }
  }

  @override
  void onContactExit(GameComponent component) {
    canMove = true;
  }
}
