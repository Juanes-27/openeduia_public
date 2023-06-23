import 'package:flutter/material.dart';
import 'package:Openedu.IA/constants/constants.dart' as globals;
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:step_progress_indicator/step_progress_indicator.dart';

Future getStudentsInfo(BuildContext context, String groupIndex) async {
  int currentIndex = int.parse(groupIndex) + 1;
  String studentsCount = "0";
  List<String> studentsVerification = [];
  List<String> studentsRool = [];
  List<String> studentsIds = [];
  List<String> studentsFirstNames = [];
  List<String> studentsLastNames = [];
  List<String> studentsEmails = [];
  List<String> studentsCompletedChallenges = [];
  List<String> studentsIcons = [];
  List<String> studentsWorldProgress = [];
  List<String> studentsSubsectionProgress = [];

  if (kIsWeb) {
    try {
      final _auth = web_auth.FirebaseAuth.instance;
      var user = await _auth.currentUser;
      web_firestore.CollectionReference ref =
          web_firestore.FirebaseFirestore.instance.collection('users');
      await ref
          .doc(user!.uid)
          .collection('students_groups')
          .doc('group_${currentIndex.toString()}')
          .get()
          .then((web_firestore.DocumentSnapshot documentSnapshot) {
        studentsCount = documentSnapshot['students_count'];
      });
      if (int.parse(studentsCount) >= 1) {
        for (int i = 1; i <= int.parse(studentsCount); i++) {
          await ref
              .doc(user.uid)
              .collection('students_groups')
              .doc('group_${currentIndex.toString()}')
              .collection('students')
              .doc('student_${i}')
              .get()
              .then((web_firestore.DocumentSnapshot documentSnapshot) {
            studentsIds.add(documentSnapshot['id']);
          });
        }
        for (int i = 1; i <= studentsIds.length; i++) {
          try {
            await ref
                .doc(studentsIds[i].toString())
                .get()
                .then((web_firestore.DocumentSnapshot documentSnapshot) {
              studentsRool.add(documentSnapshot['rool']);
              studentsVerification.add('goodId');
            });
          } catch (e) {
            studentsVerification.add('badId');
          }
        }
        for (int i = 1; i <= studentsRool.length; i++) {
          if (studentsRool[i] == "student" &&
              studentsVerification[i] == "goodId") {
            await ref
                .doc(studentsIds[i].toString())
                .get()
                .then((web_firestore.DocumentSnapshot documentSnapshot) {
              studentsFirstNames.add(documentSnapshot['first_name']);
              studentsLastNames.add(documentSnapshot['last_name']);
              studentsEmails.add(documentSnapshot['email']);
              studentsCompletedChallenges
                  .add(documentSnapshot['challenges_count']);
              studentsIcons.add(documentSnapshot['icon']);
              studentsWorldProgress.add(documentSnapshot['world_progress']);
              studentsSubsectionProgress
                  .add(documentSnapshot['subsection_progress']);
            });
          }
        }
      }
      return [
        studentsCount,
        studentsVerification,
        studentsRool,
        studentsFirstNames,
        studentsLastNames,
        studentsEmails,
        studentsCompletedChallenges,
        studentsWorldProgress,
        studentsSubsectionProgress,
        studentsIcons
      ];
    } catch (e) {
      showInSnackBar('Error-> ${e}', context);
    }
  } else {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      var ref = Firestore.instance
          .collection('users')
          .document(user.id)
          .collection('students_groups')
          .document('group_${currentIndex.toString()}');
      var query = await ref.get();
      studentsCount = query['students_count'];

      if (int.parse(studentsCount) >= 1) {
        for (int i = 1; i <= int.parse(studentsCount); i++) {
          var ref = Firestore.instance
              .collection('users')
              .document(user.id)
              .collection('students_groups')
              .document('group_${currentIndex.toString()}')
              .collection('students')
              .document('student_${i}');
          var query = await ref.get();
          studentsIds.add(query['id']);
          print("id ${studentsIds[0]}");
        }
        for (int i = 0; i <= studentsIds.length - 1; i++) {
          try {
            var ref =
                Firestore.instance.collection('users').document(studentsIds[i]);
            var query = await ref.get();
            studentsRool.add(query['rool']);
            studentsFirstNames.add(query['first_name']);
            studentsLastNames.add(query['last_name']);
            studentsEmails.add(query['email']);
            studentsIcons.add(query['icon']);
            if (studentsRool[i] == "student") {
              studentsCompletedChallenges.add(query['challenges_count']);
              studentsWorldProgress.add(query['world_progress']);
              studentsSubsectionProgress.add(query['subsection_progress']);
            }
          } catch (e) {
            studentsRool.add(query['rool']);
            studentsFirstNames.add('unkwnown');
            studentsLastNames.add('unkwnown');
            studentsEmails.add('unkwnown');
            studentsIcons.add('user_00');
            studentsCompletedChallenges.add('unkwnown');
            studentsWorldProgress.add('unkwnown');
            studentsSubsectionProgress.add('unkwnown');
          }
        }
      }
      return [
        studentsCount,
        studentsVerification,
        studentsRool,
        studentsFirstNames,
        studentsLastNames,
        studentsEmails,
        studentsCompletedChallenges,
        studentsWorldProgress,
        studentsSubsectionProgress,
        studentsIcons
      ];
    } catch (e) {
      print(e);
      showInSnackBar('Error-> ${e}', context);
    }
  }
}

class CustomGroupInfoBody extends StatelessWidget {
  final String groupName;
  final String studentsCount;
  final String groupIndex;
  const CustomGroupInfoBody(
      {Key? key,
      required this.groupName,
      required this.studentsCount,
      required this.groupIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.indigo,
          toolbarHeight: 100,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(70),
                  bottomLeft: Radius.circular(70))),
          title: Text(
            this.groupName,
            textAlign: TextAlign.justify,
            maxLines: 3,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomConfigGroupBody(
                            groupName: this.groupName,
                            groupIndex: groupIndex)));
              },
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 30,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: getStudentsInfo(context, this.groupIndex),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Column(children: [
                          if (int.parse(snapshot.data[0]) > 0)
                            ListView.separated(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: int.parse(snapshot.data[0]),
                              itemBuilder: (context, index) {
                                int _rewards_count = 0;
                                if (snapshot.data[2][index] == "student") {
                                  if (int.parse(snapshot.data[6][index]) > 0) {
                                    print(
                                        "Valor Challenges -> ${snapshot.data[6][index]}");
                                    for (int i = 1;
                                        i <= int.parse(snapshot.data[6][index]);
                                        i++) {
                                      _rewards_count += globals
                                              .numberRewardsByChallengeWorlds[
                                          i - 1];
                                    }
                                  }
                                }

                                print(_rewards_count);

                                return GestureDetector(
                                  onTap: () {
                                    print(
                                        "subsection_progress ->${snapshot.data[8][index]} world_progress -> ${snapshot.data[7][index]}");
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: FadeInImage(
                                              image: AssetImage(
                                                  'assets/images/user/${snapshot.data[9][index]}.png'),
                                              placeholder: AssetImage(
                                                  'assets/icon/loading.gif'),
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${snapshot.data[5][index]}",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          title: Text(
                                            "${snapshot.data[3][index]} ${snapshot.data[4][index]}",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                color: globals.pinkColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                        if (snapshot.data[2][index] ==
                                            "teacher")
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Text(
                                              "Este usuario ha cambiado su tipo de cuenta de Estudiante a Profesor.",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        if (snapshot.data[2][index] ==
                                            "student")
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Challenges completados",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.indigo,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                StepProgressIndicator(
                                                  totalSteps:
                                                      globals.totalChallenges,
                                                  currentStep: int.parse(
                                                      snapshot.data[6][index]),
                                                  size: 40,
                                                  selectedColor: Colors.indigo,
                                                  unselectedColor: Colors.grey,
                                                  roundedEdges:
                                                      Radius.circular(10),
                                                  customStep:
                                                      (index, color, _) =>
                                                          color == Colors.indigo
                                                              ? Container(
                                                                  width: 50,
                                                                  color: color,
                                                                  child: Icon(
                                                                    Icons
                                                                        .military_tech,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 20,
                                                                  ),
                                                                )
                                                              : Container(
                                                                  width: 50,
                                                                  color: color,
                                                                  child: Icon(
                                                                    Icons
                                                                        .do_disturb_off_outlined,
                                                                  ),
                                                                ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5,
                                                          right: 5,
                                                          top: 10),
                                                  child: Text(
                                                    "El estudiante tiene completado ${int.parse(snapshot.data[6][index])} de ${globals.totalChallenges} challenges.",
                                                    textAlign:
                                                        TextAlign.justify,
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Recompensas obtenidas",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.indigo,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                if (int.parse(snapshot.data[6]
                                                            [index]
                                                        .toString()) ==
                                                    0)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Text(
                                                        "El estudiante no tiene ninguna recompensa por el momento.",
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20)),
                                                  ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                if (int.parse(snapshot.data[6]
                                                            [index]
                                                        .toString()) >
                                                    0)
                                                  Row(
                                                    children: [
                                                      CircularStepProgressIndicator(
                                                        totalSteps: globals
                                                            .rewardsTotalPoints,
                                                        currentStep: int.parse(
                                                            snapshot.data[6]
                                                                    [index]
                                                                .toString()),
                                                        selectedColor:
                                                            Colors.indigo,
                                                        unselectedColor:
                                                            Colors.grey,
                                                        padding: 0,
                                                        width: 100,
                                                        child: Icon(
                                                          Icons.monetization_on,
                                                          color: Colors.indigo,
                                                          size: 84,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          "Total de Recompensas ${snapshot.data[6][index]}",
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20)),
                                                    ],
                                                  ),
                                                Text(
                                                  "Puntos obtenidos",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.indigo,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10,
                                                          bottom: 10),
                                                  child: StepProgressIndicator(
                                                    totalSteps: globals
                                                        .totalpointsSubsections,
                                                    currentStep:
                                                        globals.sumTwoDimensionalList(
                                                            globals
                                                                .valuesPointsSubsectionsperWorld,
                                                            int.parse(snapshot
                                                                        .data[7]
                                                                    [index]) -
                                                                1,
                                                            int.parse(
                                                                snapshot.data[8]
                                                                    [index])),
                                                    size: 8,
                                                    padding: 0,
                                                    selectedColor:
                                                        Colors.indigo,
                                                    unselectedColor:
                                                        Colors.grey,
                                                    roundedEdges:
                                                        Radius.circular(10),
                                                    selectedGradientColor:
                                                        LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Colors.indigo,
                                                        Colors.indigo
                                                      ],
                                                    ),
                                                    unselectedGradientColor:
                                                        LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Colors.grey,
                                                        Colors.grey
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "El estudiante va ${globals.sumTwoDimensionalList(globals.valuesPointsSubsectionsperWorld, int.parse(snapshot.data[7][index]) - 1, int.parse(snapshot.data[8][index]))} de ${globals.totalpointsSubsections} puntos.",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Progreso de Mundos",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.indigo,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, right: 5),
                                                  child: StepProgressIndicator(
                                                    totalSteps:
                                                        globals.numberWorlds -
                                                            1,
                                                    currentStep: int.parse(
                                                        snapshot.data[7]
                                                            [index]),
                                                    selectedColor:
                                                        Colors.indigo,
                                                    unselectedColor:
                                                        Colors.grey,
                                                    roundedEdges:
                                                        Radius.circular(10),
                                                    size: 40,
                                                    customStep: (index, color,
                                                            _) =>
                                                        color == Colors.indigo
                                                            ? Container(
                                                                width: 50,
                                                                color: color,
                                                                child: Icon(
                                                                  Icons
                                                                      .emoji_flags,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                ),
                                                              )
                                                            : Container(
                                                                width: 50,
                                                                color: color,
                                                                child: Icon(
                                                                  Icons
                                                                      .public_off_outlined,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Text(
                                            "El estudiante está en el mundo ${globals.worldsNames[int.parse(snapshot.data[7][index]) - 1]}.",
                                            textAlign: TextAlign.justify,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Text(
                                                "Progreso de Subsecciones",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: StepProgressIndicator(
                                            totalSteps:
                                                globals.worldIndexSubsections[
                                                    int.parse(snapshot.data[7]
                                                            [index]) -
                                                        1],
                                            currentStep: int.parse(
                                                    snapshot.data[8][index]) +
                                                1,
                                            selectedColor: Colors.indigo,
                                            unselectedColor: Colors.grey,
                                            roundedEdges: Radius.circular(10),
                                            size: 40,
                                            customStep: (index, color, _) =>
                                                color == Colors.indigo
                                                    ? Container(
                                                        width: 50,
                                                        color: color,
                                                        child: Icon(
                                                          Icons
                                                              .event_available_outlined,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 50,
                                                        color: color,
                                                        child: Icon(
                                                          Icons.priority_high,
                                                          size: 20,
                                                        ),
                                                      ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Text(
                                            "El estudiante está cursando la subsección de ${globals.subsectionsName[int.parse(snapshot.data[7][index]) - 1][int.parse(snapshot.data[8][index])]} del mundo ${globals.worldsNames[int.parse(snapshot.data[7][index]) - 1]}.",
                                            textAlign: TextAlign.justify,
                                            maxLines: 3,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext _, int __) =>
                                  const Divider(
                                color: Colors.purpleAccent,
                                thickness: 5.0,
                              ),
                            ),
                          if (snapshot.data[0] == "0")
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                "No hay estudiantes agregados dentro de este grupo.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                        ]);
                      } else {
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height / 4,
                            ),
                            Center(
                              child: Text(
                                'Cargando ...',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 36),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: CircularProgressIndicator(
                                color: Colors.indigo,
                              ),
                            )
                          ],
                        );
                      }
                    }),
                SizedBox(
                  height: 10,
                )
              ]),
        ));
  }
}
