import 'package:flutter/material.dart';
import 'package:Openedu.IA/constants/constants.dart' as globals;
import 'package:Openedu.IA/widgets/widgets.dart';

class CustomConfigGroupBody extends StatelessWidget {
  final String groupName;
  final String groupIndex;
  const CustomConfigGroupBody(
      {Key? key, required this.groupName, required this.groupIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> nameConfigs = [
      "Editar nombre del grupo",
      "Agregar estudiante"
    ];
    List<Widget> optionsScreens = [
      CustomConfigGroupChangeName(
        groupIndex: this.groupIndex,
        groupName: this.groupName,
      ),
      CustomGroupAddStudent(
        groupIndex: this.groupIndex,
        groupName: this.groupName,
      ),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text("Configuración del Grupo"),
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: nameConfigs.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => optionsScreens[index]));
            },
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "${nameConfigs[index]}",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: FadeInImage(
                        image: AssetImage(
                            'assets/worlds/worlds_subsections_icons/${globals.subsectionsIcons[index]}'),
                        placeholder: AssetImage('assets/icon/loading.gif'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
