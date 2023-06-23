import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';

class WelcomeStudentScreen extends StatelessWidget {
  const WelcomeStudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(children: const [
            CustomWelcomeStudentBackground(),
            CustomWelcomeStudentBody()
          ])),
    );
  }
}
