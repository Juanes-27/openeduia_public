import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:flutter/services.dart';

class HomeProfessorScreen extends StatefulWidget {
  const HomeProfessorScreen({Key? key}) : super(key: key);

  @override
  State<HomeProfessorScreen> createState() => _HomeProfessorScreenState();
}

class _HomeProfessorScreenState extends State<HomeProfessorScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Stack(children: [
              const ProfessorBackground(),
              CustomProfessorActiveGroupsScreen()
            ]),
          ),
        ),
      ),
    );
  }
}
