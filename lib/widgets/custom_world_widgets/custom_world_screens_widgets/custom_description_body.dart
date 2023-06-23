import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Openedu.IA/constants/constants.dart' as globals;

Future getWorldDescription(int world_index, BuildContext context) async {
  int world_id = world_index + 1;
  List<String> worldDescription = [];
  List<String> worldVideoId = ["dsafsdf"];
  List<String> worldDuration = [];
  List<String> worldLearningGoals = [];

  if (kIsWeb) {
    for (int worldLearningGoal = 1;
        worldLearningGoal <= globals.worldsLearningGoals[world_index];
        worldLearningGoal++) {
      try {
        web_firestore.CollectionReference ref =
            web_firestore.FirebaseFirestore.instance.collection('worlds');
        await ref
            .doc('world_0${world_id}')
            .collection('learning_objectives')
            .doc('objective_0${worldLearningGoal}')
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) {
          worldLearningGoals.add(documentSnapshot['description'.toString()]);
        });
      } catch (e) {
        showInSnackBar('Error-> ${e}', context);
      }
    }
    for (int index = 1;
        index <= globals.worldIndexSubsections[world_index];
        index++) {
      try {
        web_firestore.CollectionReference ref =
            web_firestore.FirebaseFirestore.instance.collection('worlds');
        await ref
            .doc('world_0${world_id}')
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) {
          worldDescription.add(documentSnapshot['description'.toString()]);
          worldDuration.add(documentSnapshot['duration'.toString()]);
        });
      } catch (e) {
        showInSnackBar('Error-> ${e}', context);
      }
    }
    return [worldDescription, worldVideoId, worldDuration, worldLearningGoals];
  } else {
    for (int worldLearningGoal = 1;
        worldLearningGoal <= globals.worldsLearningGoals[world_index];
        worldLearningGoal++) {
      try {
        var ref = Firestore.instance
            .collection('worlds')
            .document('world_0${world_id}')
            .collection('learning_objectives')
            .document('objective_0${worldLearningGoal}');
        var query = await ref.get();
        worldLearningGoals.add(query['description'].toString());
      } catch (e) {
        showInSnackBar('Error-> ${e}', context);
      }
    }
    for (int index = 1;
        index <= globals.worldIndexSubsections[world_index];
        index++) {
      try {
        var ref = Firestore.instance
            .collection('worlds')
            .document('world_0${world_id}');
        var query = await ref.get();
        worldDescription.add(query['description'].toString());
        worldDuration.add(query['duration'.toString()]);
      } catch (e) {
        showInSnackBar('Error-> ${e}', context);
      }
    }
    return [worldDescription, worldVideoId, worldDuration, worldLearningGoals];
  }
}

class DescriptionWorldScreen extends StatelessWidget {
  final int world_index;
  DescriptionWorldScreen({Key? key, required this.world_index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: getWorldDescription(world_index, context),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text(
                          snapshot.data[0][0].toString(),
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Duración del Mundo: ${snapshot.data[2][0]}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Objetivos de Aprendizaje del Mundo',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: globals.pinkColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListView.separated(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: globals.worldsLearningGoals[world_index],
                          itemBuilder: (context, index) => Card(
                            child: Column(
                              children: [
                                ListTile(
                                  subtitle: Text(
                                    snapshot.data[3][index],
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: FadeInImage(
                                      image: AssetImage(
                                          'assets/worlds/worlds_subsections_icons/${globals.subsectionsIcons[index]}'),
                                      placeholder:
                                          AssetImage('assets/icon/loading.gif'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          separatorBuilder: (BuildContext _, int __) =>
                              const Divider(),
                        )
                      ],
                    );
                  } else {
                    return Center(
                        child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Cargando ...',
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CircularProgressIndicator(
                          color: Colors.indigo,
                        )
                      ],
                    ));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
