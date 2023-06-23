import 'package:flutter/material.dart';
import 'package:bonfire/state_manager/bonfire_injector.dart';
import 'package:Openedu.IA/screens/screens.dart';
import 'package:Openedu.IA/widgets/custom_world_widgets/custom_challenges_widgets/custom_pacman_challenge_widgets/custom_pacman_challenge_widgets.dart';

class PacManGameOverDialogScreen extends StatelessWidget {
  const PacManGameOverDialogScreen({Key? key}) : super(key: key);
  static show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const PacManGameOverDialogScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GameState gameState = BonfireInjector.instance.get();
    TextStyle textStyle = const TextStyle(color: Colors.white);
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Final del Juego',
                style: textStyle.copyWith(
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  overlayColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.2),
                  ),
                  side: MaterialStateProperty.all(
                    const BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  gameState.reset();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return HomeStudentScreen();
                  }), (route) => false);
                },
                child: Text(
                  'Sigue Intentando',
                  style: textStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
