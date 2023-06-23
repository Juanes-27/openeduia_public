import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/custom_world_widgets/custom_challenges_widgets/custom_pacman_challenge_widgets/custom_pacman_challenge_widgets.dart';
import 'package:Openedu.IA/screens/worlds/challenges_worlds/challenges_worlds.dart';
import '../../../../screens/worlds/challenges_worlds/challenges_world_01/pacman_game_world_01/pacman_homescreen.dart';

enum GhostType { red, blue, pink, orange }

enum GhostState { normal, vulnerable, die }

class Ghost extends SimpleEnemy
    with ObjectCollision, AutomaticRandomMovement, MoveToPositionAlongThePath {
  static const normalSpeed = 140.0;
  static const vulnerableSpeed = 90.0;
  static const dieSpeed = 240.0;
  GhostState state = GhostState.normal;
  final Vector2 _startPositionAfterDie = Vector2(
    PacManWorld1HomeScreen.tileSize * 9,
    PacManWorld1HomeScreen.tileSize * 9,
  );
  late GameState _gameState;
  final GhostType type;

  bool enabledBeheavor = false;
  Ghost({
    required super.position,
    this.type = GhostType.red,
  }) : super(
          size: Vector2.all(PacManWorld1HomeScreen.tileSize),
          animation: GhostSpriteSheet.getByType(type),
          speed: normalSpeed,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: size - Vector2.all(4),
            align: Vector2.all(2),
          ),
        ],
      ),
    );

    setupMoveToPositionAlongThePath(
      pathLineColor: Colors.transparent,
    );
  }

  @override
  void update(double dt) {
    if (enabledBeheavor && !isMovingAlongThePath) {
      seePlayer(
        observed: (player) {
          bool move = false;
          if (state == GhostState.vulnerable) {
            move = positionsItselfAndKeepDistance(
              player,
              positioned: (_) {},
              minDistanceFromPlayer: PacManWorld1HomeScreen.tileSize * 3,
            );
          } else {
            move = followComponent(
              player,
              dt,
              closeComponent: (_) {},
              margin: -10,
            );
          }
          if (!move) {
            _runRandom(dt);
          }
        },
        radiusVision: PacManWorld1HomeScreen.tileSize * 2,
        notObserved: () => _runRandom(dt),
      );
    }
    super.update(dt);
  }

  void _runRandom(double dt) {
    runRandomMovement(
      dt,
      speed: speed,
      maxDistance: (PacManWorld1HomeScreen.tileSize * 4).toInt(),
      minDistance: (PacManWorld1HomeScreen.tileSize * 4).toInt(),
      timeKeepStopped: 0,
    );
  }

  void bite() {
    state = GhostState.die;
    enabledBeheavor = false;
    final animation = GhostSpriteSheet.runEyes;
    replaceAnimation(
      SimpleDirectionAnimation(
        idleRight: animation,
        runRight: animation,
      ),
    );

    speed = dieSpeed;
    moveToPositionAlongThePath(
      _startPositionAfterDie,
      ignoreCollisions: ignoreableCollisions,
      onFinish: _removeEyeAnimation,
    );
  }

  List<dynamic> get ignoreableCollisions {
    return [
      gameRef.player,
      ...gameRef.enemies(),
    ];
  }

  @override
  void onMount() {
    _gameState = BonfireInjector.instance.get();
    _gameState.listenChangePower(_pacManChangePower);
    _startInitialMovement();
    super.onMount();
  }

  void _startInitialMovement({bool withDelay = true}) async {
    switch (type) {
      case GhostType.red:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 1));
        }
        moveToPositionAlongThePath(
          Vector2(PacManWorld1HomeScreen.tileSize * 4,
              PacManWorld1HomeScreen.tileSize * 3),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
      case GhostType.blue:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 6));
        }
        moveToPositionAlongThePath(
          Vector2(PacManWorld1HomeScreen.tileSize * 14,
              PacManWorld1HomeScreen.tileSize * 3),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
      case GhostType.pink:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 11));
        }
        moveToPositionAlongThePath(
          Vector2(PacManWorld1HomeScreen.tileSize * 4,
              PacManWorld1HomeScreen.tileSize * 13),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
      case GhostType.orange:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 16));
        }
        moveToPositionAlongThePath(
          Vector2(PacManWorld1HomeScreen.tileSize * 14,
              PacManWorld1HomeScreen.tileSize * 13),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
    }
  }

  void _removeEyeAnimation() {
    state = GhostState.normal;
    speed = normalSpeed;
    replaceAnimation(GhostSpriteSheet.getByType(type));
    _startInitialMovement(withDelay: false);
  }

  @override
  bool onCollision(GameComponent component, bool active) {
    if (component is Ghost || component is PacMan) {
      return false;
    }
    return super.onCollision(component, active);
  }

  void _pacManChangePower(bool value) {
    if (value) {
      state = GhostState.vulnerable;
      speed = vulnerableSpeed;
      final animation = GhostSpriteSheet.runPower;
      replaceAnimation(
        SimpleDirectionAnimation(
          idleRight: animation,
          runRight: animation,
        ),
      );
    } else if (state != GhostState.die) {
      state = GhostState.normal;
      speed = normalSpeed;
      replaceAnimation(GhostSpriteSheet.getByType(type));
    }
  }
}
