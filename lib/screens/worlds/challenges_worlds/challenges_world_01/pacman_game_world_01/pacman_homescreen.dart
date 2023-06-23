import 'package:flutter/material.dart';
import 'dart:math';
import 'package:bonfire/bonfire.dart';
import 'package:Openedu.IA/widgets/custom_world_widgets/custom_challenges_widgets/custom_pacman_challenge_widgets/custom_pacman_challenge_widgets.dart';

class PacManWorld1HomeScreen extends StatelessWidget {
  static const double heightMap = 1004.0;
  static const double tileSize = 48.0;
  const PacManWorld1HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    BonfireInjector.instance.put((i) => GameState());
    Size sizeScreen = MediaQuery.of(context).size;
    double size = min(sizeScreen.width, sizeScreen.height);
    double zoom = size / heightMap;
    return Container(
      color: Colors.black,
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: BonfireWidget(
            map: WorldMapByTiled(
              'map.tmj',
              objectsBuilder: {
                'sensor_left': (properties) => SensorGate(
                      position: properties.position,
                      direction: DiractionGate.left,
                    ),
                'sensor_right': (properties) => SensorGate(
                      position: properties.position,
                      direction: DiractionGate.right,
                    ),
                'dot': (properties) => Dot(
                      position: properties.position,
                    ),
                'dot_power': (properties) => DotPower(
                      position: properties.position,
                    ),
                'ghost_red': (properties) => Ghost(
                      position: properties.position,
                      type: GhostType.red,
                    ),
                'ghost_pink': (properties) => Ghost(
                      position: properties.position,
                      type: GhostType.pink,
                    ),
                'ghost_orange': (properties) => Ghost(
                      position: properties.position,
                      type: GhostType.orange,
                    ),
                'ghost_blue': (properties) => Ghost(
                      position: properties.position,
                      type: GhostType.blue,
                    ),
              },
            ),
            joystick: Joystick(
              keyboardConfig: KeyboardConfig(),
              directional: JoystickDirectional(
                  size: 60,
                  color: Colors.indigo,
                  isFixed: false,
                  margin: EdgeInsets.only(left: 40, bottom: 40)),
            ),
            overlayBuilderMap: {
              'score': ((context, game) => const InterfaceGame()),
            },
            initialActiveOverlays: const ['score'],
            cameraConfig: CameraConfig(
              zoom: zoom,
            ),
            player: PacMan(
              position: PacMan.initialPosition,
            ),
          ),
        ),
      ),
    );
  }
}
