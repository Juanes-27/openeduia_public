import 'package:Openedu.IA/screens/student_screens/student_screens.dart';
import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Openedu.IA/constants/constants.dart' as globals;
import 'package:quickalert/quickalert.dart';

Future getUserProgress(BuildContext context) async {
  String world_progress = "";
  String subsections_progress = "";
  if (kIsWeb) {
    try {
      final _auth = web_auth.FirebaseAuth.instance;
      var user = await _auth.currentUser;

      web_firestore.CollectionReference ref =
          web_firestore.FirebaseFirestore.instance.collection('users');
      await ref
          .doc(user!.uid)
          .get()
          .then((web_firestore.DocumentSnapshot documentSnapshot) {
        world_progress = documentSnapshot['world_progress'].toString();
        subsections_progress =
            documentSnapshot['subsection_progress'].toString();
      });
    } catch (e) {
      showInSnackBar('Error-> ${e}', context);
    }
  } else {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      var ref = Firestore.instance.collection('users').document(user.id);
      var query = await ref.get();
      world_progress = query['world_progress'].toString();
      subsections_progress = query['subsection_progress'].toString();
    } catch (e) {
      showInSnackBar('Error-> ${e}', context);
    }
  }
  return [world_progress, subsections_progress];
}

getCorrectAnswer(List<String> quizOptions, String correctAnswer) {
  for (int index = 0; index < quizOptions.length; index++) {
    if (correctAnswer == quizOptions[index]) {
      return index + 1;
    }
  }
  return -1;
}

Future completedSection(BuildContext context, String actualWorld, worldProgress,
    actualSubsection, subsectionProgress) async {
  if (kIsWeb) {
    try {
      final _auth = web_auth.FirebaseAuth.instance;
      var user = await _auth.currentUser;
      web_firestore.CollectionReference ref =
          web_firestore.FirebaseFirestore.instance.collection('users');
      if (int.parse(actualWorld) + 1 == int.parse(worldProgress)) {
        if (worldProgress == "5") {
          await ref
              .doc(user!.uid)
              .update({'subsection_progress': '0', 'world_progress': '6'});
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return HomeStudentScreen();
          }), (route) => false);
          showInSnackBar(' completada !', context);
        }
        if (int.parse(subsectionProgress) > int.parse(actualSubsection) &&
            int.parse(subsectionProgress) <
                globals.worldIndexSubsections[int.parse(actualWorld)]) {
          if (int.parse(worldProgress) < 6)
            await ref.doc(user!.uid).update({
              'subsection_progress':
                  (int.parse(subsectionProgress) + 1).toString()
            });
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return HomeStudentScreen();
          }), (route) => false);
          showInSnackBar('Sección completada !', context);
        }
        if (int.parse(subsectionProgress) ==
            globals.worldIndexSubsections[int.parse(actualWorld)] - 1) {
          if (int.parse(worldProgress) < 6)
            await ref.doc(user!.uid).update({
              'subsection_progress': '0',
              'world_progress': (int.parse(actualWorld) + 2).toString()
            });
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return HomeStudentScreen();
          }), (route) => false);
          if (actualWorld != "5")
            showInSnackBar('Mundo nuevo desbloqueado', context);
          if (actualWorld == "5") {
            showInSnackBar(
                'Terminaste todos los mundos, felicitaciones!', context);
          }
        }
        if (int.parse(actualSubsection) == int.parse(subsectionProgress)) {
          if (int.parse(subsectionProgress) <
              globals.worldIndexSubsections[int.parse(worldProgress) - 1]) {
            if (int.parse(worldProgress) < 6)
              await ref.doc(user!.uid).update({
                'subsection_progress':
                    (int.parse(subsectionProgress) + 1).toString()
              });
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return HomeStudentScreen();
            }), (route) => false);
            showInSnackBar('Sección completada !', context);
          }
        } else {
          if (int.parse(subsectionProgress) ==
                  globals.worldIndexSubsections[int.parse(actualWorld)] - 1 &&
              int.parse(worldProgress) <= 6) {
            if (int.parse(worldProgress) < 6)
              await ref.doc(user!.uid).update({
                'subsection_progress': '0',
                'world_progress': (int.parse(actualWorld) + 2).toString()
              });
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return HomeStudentScreen();
            }), (route) => false);
            showInSnackBar('Mundo nuevo desbloqueado', context);
          }
          if (int.parse(worldProgress) == 6) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return HomeStudentScreen();
            }), (route) => false);
            showInSnackBar(
                'Terminaste todos los mundos, felicitaciones!', context);
          }
          if (int.parse(subsectionProgress) > int.parse(actualSubsection) &&
              int.parse(subsectionProgress) <
                  globals.worldIndexSubsections[int.parse(actualWorld)] - 1) {
            if (int.parse(worldProgress) < 6)
              await ref.doc(user!.uid).update({
                'subsection_progress':
                    (int.parse(subsectionProgress) + 1).toString()
              });
          }
        }
      }
    } catch (e) {
      showInSnackBar('Error ${e}', context);
    }
  } else {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      var ref = Firestore.instance.collection('users').document(user.id);
      if (int.parse(actualWorld) + 1 == int.parse(worldProgress)) {
        if (worldProgress == "5") {
          await ref.update({'subsection_progress': '0', 'world_progress': '6'});
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return HomeStudentScreen();
          }), (route) => false);
          showInSnackBar(' completada !', context);
        }
        if (int.parse(subsectionProgress) > int.parse(actualSubsection) &&
            int.parse(subsectionProgress) <
                globals.worldIndexSubsections[int.parse(actualWorld)]) {
          if (int.parse(worldProgress) < 6)
            await ref.update({
              'subsection_progress':
                  (int.parse(subsectionProgress) + 1).toString()
            });
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return HomeStudentScreen();
          }), (route) => false);
          showInSnackBar('Sección completada !', context);
        }
        if (int.parse(subsectionProgress) ==
            globals.worldIndexSubsections[int.parse(actualWorld)] - 1) {
          if (int.parse(worldProgress) < 6)
            await ref.update({
              'subsection_progress': '0',
              'world_progress': (int.parse(actualWorld) + 2).toString()
            });
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return HomeStudentScreen();
          }), (route) => false);
          if (actualWorld != "5")
            showInSnackBar('Mundo nuevo desbloqueado', context);
          if (actualWorld == "5") {
            showInSnackBar(
                'Terminaste todos los mundos, felicitaciones!', context);
          }
        }
        if (int.parse(actualSubsection) == int.parse(subsectionProgress)) {
          if (int.parse(subsectionProgress) <
              globals.worldIndexSubsections[int.parse(worldProgress) - 1]) {
            if (int.parse(worldProgress) < 6)
              await ref.update({
                'subsection_progress':
                    (int.parse(subsectionProgress) + 1).toString()
              });
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return HomeStudentScreen();
            }), (route) => false);
            showInSnackBar('Sección completada !', context);
          }
        } else {
          if (int.parse(subsectionProgress) ==
                  globals.worldIndexSubsections[int.parse(actualWorld)] - 1 &&
              int.parse(worldProgress) <= 6) {
            if (int.parse(worldProgress) < 6)
              await ref.update({
                'subsection_progress': '0',
                'world_progress': (int.parse(actualWorld) + 2).toString()
              });
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return HomeStudentScreen();
            }), (route) => false);
            showInSnackBar('Mundo nuevo desbloqueado', context);
          }
          if (int.parse(worldProgress) == 6) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return HomeStudentScreen();
            }), (route) => false);
            showInSnackBar(
                'Terminaste todos los mundos, felicitaciones!', context);
          }
          if (int.parse(subsectionProgress) > int.parse(actualSubsection) &&
              int.parse(subsectionProgress) <
                  globals.worldIndexSubsections[int.parse(actualWorld)] - 1) {
            if (int.parse(worldProgress) < 6)
              await ref.update({
                'subsection_progress':
                    (int.parse(subsectionProgress) + 1).toString()
              });
          }
        }
      } else {
        if (int.parse(actualWorld) + 1 < int.parse(worldProgress)) {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return HomeStudentScreen();
          }), (route) => false);
          showInSnackBar(
              'Ya habias respondido correctamente el quiz anteriormente',
              context);
        }
      }
    } catch (e) {
      showInSnackBar('Error ${e}', context);
    }
  }
}

class CustomWorldSubsecionShowQuiz extends StatelessWidget {
  final String actualWorld;
  final String actualSubsection;
  final String quizQuestion;
  final String quizCorrectAnswer;
  final String quizFirstOption;
  final String quizSecondOption;
  final String quizThreeOption;
  final String quizFourOption;
  const CustomWorldSubsecionShowQuiz({
    Key? key,
    required this.actualWorld,
    required this.actualSubsection,
    required this.quizQuestion,
    required this.quizCorrectAnswer,
    required this.quizFirstOption,
    required this.quizSecondOption,
    required this.quizThreeOption,
    required this.quizFourOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: width,
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: getUserProgress(context),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<String> quizOptions = [
                    this.quizFirstOption,
                    this.quizSecondOption,
                    this.quizThreeOption,
                    this.quizFourOption
                  ];
                  int indexQuizAnswer = -1;
                  indexQuizAnswer =
                      getCorrectAnswer(quizOptions, this.quizCorrectAnswer);

                  print("worldProgresss -> ${snapshot.data[0]}");
                  if (indexQuizAnswer != -1)
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pregunta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo),
                        ),
                        SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            this.quizQuestion,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Opciones',
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Text(
                              this.quizFirstOption,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              if (indexQuizAnswer == 1) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  text:
                                      'Respuesta correcta pasaste la sección!',
                                  onConfirmBtnTap: () async {
                                    completedSection(
                                        context,
                                        this.actualWorld,
                                        snapshot.data[0],
                                        this.actualSubsection,
                                        snapshot.data[1]);
                                  },
                                );
                              } else {
                                Navigator.pop(context);
                                showInSnackBar(
                                    "Respuesta incorrecta vuelve a intentarlo",
                                    context);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Text(
                              this.quizSecondOption,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              if (indexQuizAnswer == 2) {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    text:
                                        'Respuesta correcta pasaste la sección!',
                                    onConfirmBtnTap: () async {
                                      completedSection(
                                          context,
                                          this.actualWorld,
                                          snapshot.data[0],
                                          this.actualSubsection,
                                          snapshot.data[1]);
                                    });
                              } else {
                                Navigator.pop(context);
                                showInSnackBar(
                                    "Respuesta incorrecta vuelve a intentarlo",
                                    context);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Text(
                              this.quizThreeOption,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              if (indexQuizAnswer == 3) {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    text:
                                        'Respuesta correcta pasaste la sección!',
                                    onConfirmBtnTap: () async {
                                      completedSection(
                                          context,
                                          this.actualWorld,
                                          snapshot.data[0],
                                          this.actualSubsection,
                                          snapshot.data[1]);
                                    });
                              } else {
                                Navigator.pop(context);
                                showInSnackBar(
                                    "Respuesta incorrecta vuelve a intentarlo",
                                    context);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Text(
                              this.quizFourOption,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            onPressed: () async {
                              print(indexQuizAnswer);
                              if (indexQuizAnswer == 4) {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    text:
                                        'Respuesta correcta pasaste la sección!',
                                    onConfirmBtnTap: () {
                                      completedSection(
                                          context,
                                          this.actualWorld,
                                          snapshot.data[0],
                                          this.actualSubsection,
                                          snapshot.data[1]);
                                    });
                              } else {
                                Navigator.pop(context);
                                showInSnackBar(
                                    "Respuesta incorrecta vuelve a intentarlo",
                                    context);
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  else
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, top: 10),
                      child: Text(
                        "Error Cargando Pregunta intentalo de nuevo",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
        ),
      ),
    );
  }
}
