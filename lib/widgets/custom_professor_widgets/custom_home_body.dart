import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomProfessorActiveGroupsScreen extends StatelessWidget {
  const CustomProfessorActiveGroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomStudentAppBarHome(),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        height: size.height - 200,
                        width: size.width - 50,
                        child: CustomActiveGroupWidget(),
                      ),
                    ),
                  ])
            ]),
      ),
    );
  }
}
