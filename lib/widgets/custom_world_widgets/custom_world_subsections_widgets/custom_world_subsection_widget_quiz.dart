import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Openedu.IA/constants/constants.dart' as globals;
import 'dart:math';

import 'package:quickalert/quickalert.dart';

Future getquizinfo(
    int world_index, int subsection_index, BuildContext context) async {
  int world_id = world_index + 1;
  subsection_index += 1;
  String quices_count = "0";
  String questions_count = "0";
  List<String> quizName = [];
  String quizQuestion = "";
  String quizCorrectAnswer = "";
  String quizFirstOption = "";
  String quizSecondOption = "";
  String quizThreeOption = "";
  String quizFourOption = "";
  if (world_id != 7) {
    if (kIsWeb) {
      try {
        web_firestore.CollectionReference ref =
            web_firestore.FirebaseFirestore.instance.collection('worlds');
        await ref
            .doc('world_0${world_id}')
            .collection('subsections')
            .doc('subsection_0${subsection_index}')
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) {
          quices_count = documentSnapshot['quices_count'];
          questions_count = documentSnapshot['questions_count'];
        });
        for (int quices_index = 1;
            quices_index <= int.parse(quices_count);
            quices_index++) {
          web_firestore.CollectionReference ref =
              web_firestore.FirebaseFirestore.instance.collection('worlds');
          await ref
              .doc('world_0${world_id}')
              .collection('subsections')
              .doc('subsection_0${subsection_index}')
              .collection('quices')
              .doc('quiz_0${quices_index}')
              .get()
              .then((web_firestore.DocumentSnapshot documentSnapshot) {
            quizName.add(documentSnapshot['name']);
          });
        }

        int min = 1;
        int max = int.parse(questions_count);
        Random random = Random();
        int randomNumber = min + random.nextInt(max - min + 1);

        await ref
            .doc('world_0${world_id}')
            .collection('subsections')
            .doc('subsection_0${subsection_index}')
            .collection('questions')
            .doc('question_0${randomNumber.toString()}')
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) {
          quizQuestion = documentSnapshot['question'];
          quizCorrectAnswer = documentSnapshot['correct_answer'];
          quizFirstOption = documentSnapshot['first_option'];
          quizSecondOption = documentSnapshot['second_option'];
          quizThreeOption = documentSnapshot['three_option'];
          quizFourOption = documentSnapshot['four_option'];
        });
      } catch (e) {
        showInSnackBar('Error-> ${e}', context);
      }
    } else {
      try {
        var ref = Firestore.instance
            .collection('worlds')
            .document('world_0${world_id}')
            .collection('subsections')
            .document('subsection_0${subsection_index}');
        var query = await ref.get();
        quices_count = query['quices_count'];
        questions_count = query['questions_count'];
        for (int quices_index = 1;
            quices_index <= int.parse(quices_count);
            quices_index++) {
          var query = await ref
              .collection('quices')
              .document('quiz_0${quices_index}')
              .get();
          quizName.add(query['name']);
        }
        int min = 1;
        int max = int.parse(questions_count);
        Random random = Random();
        int randomNumber = min + random.nextInt(max - min + 1);

        query = await ref
            .collection('questions')
            .document('question_0${randomNumber.toString()}')
            .get();

        quizQuestion = query['question'];
        quizCorrectAnswer = query['correct_answer'];
        quizFirstOption = query['first_option'];
        quizSecondOption = query['second_option'];
        quizThreeOption = query['three_option'];
        quizFourOption = query['four_option'];
      } catch (e) {
        showInSnackBar('Error-> ${e}', context);
      }
    }
    return [
      quices_count,
      quizName,
      quizQuestion,
      quizCorrectAnswer,
      quizFirstOption,
      quizSecondOption,
      quizThreeOption,
      quizFourOption
    ];
  } else {
    return ["1", "No hay quices dentro de la sección de Python."];
  }
}

class CustomWorldSubsectionWidgetQuiz extends StatelessWidget {
  final String worldIndex;
  final String subsectionIndex;
  const CustomWorldSubsectionWidgetQuiz({
    Key? key,
    required this.worldIndex,
    required this.subsectionIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getquizinfo(int.parse(this.worldIndex),
            int.parse(this.subsectionIndex), context),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: int.parse(snapshot.data[0].toString()),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  if (this.worldIndex != "6")
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CustomWorldSubsecionShowQuiz(
                              actualWorld: this.worldIndex,
                              actualSubsection: index.toString(),
                              quizQuestion: snapshot.data[2],
                              quizCorrectAnswer: snapshot.data[3],
                              quizFirstOption: snapshot.data[4],
                              quizSecondOption: snapshot.data[5],
                              quizThreeOption: snapshot.data[6],
                              quizFourOption: snapshot.data[7],
                            )));
                  if (this.worldIndex == "6")
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Oops...',
                      text:
                          'No puedes ingresar al quiz ya que el mundo de Python no se califica.',
                    );
                },
                child: Card(
                  child: Column(
                    children: [
                      if (this.worldIndex == "6")
                        ListTile(
                          title: Text(
                            snapshot.data[1],
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
                        ),
                      if (this.worldIndex != "6")
                        ListTile(
                          title: Text(
                            snapshot.data[1][index],
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
              ),
              separatorBuilder: (BuildContext _, int __) => const Divider(),
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
        });
  }
}
