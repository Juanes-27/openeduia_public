import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomProfessorAddGroupsScreen extends StatelessWidget {
  const CustomProfessorAddGroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Grupos Estudiantiles"),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        height: size.height - 450,
                        width: size.width - 50,
                        child: CustomAddGroup(),
                      ),
                    ),
                  ])
            ]),
      ),
    );
  }
}
