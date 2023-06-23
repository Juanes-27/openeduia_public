import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:Openedu.IA/constants/constants.dart' as globals;
import 'dart:async';
import 'package:quickalert/quickalert.dart';
import 'package:Openedu.IA/widgets/widgets.dart';

Future getWorldSubsections(int world_index) async {
  int world_id = world_index + 1;
  List<String> worldSubsectionsNames = [];
  List<String> worldSubsectionsContent = [];
  List<String> worldSubsectionsDifficulty = [];
  List<String> worldSubsectionsPoints = [];
  List<String> worldSubsectionsDuration = [];
  String userSubsection_progress = "0";
  String userWorld_progress = "1";

  if (kIsWeb) {
    for (int index = 1;
        index <= globals.worldIndexSubsections[world_index];
        index++) {
      try {
        final _auth = web_auth.FirebaseAuth.instance;
        var user = await _auth.currentUser;
        web_firestore.CollectionReference user_ref =
            web_firestore.FirebaseFirestore.instance.collection('users');
        await user_ref
            .doc(user!.uid)
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) {
          userSubsection_progress =
              documentSnapshot['subsection_progress'].toString();
          userWorld_progress = documentSnapshot['world_progress'].toString();
        });
        web_firestore.CollectionReference ref =
            web_firestore.FirebaseFirestore.instance.collection('worlds');
        await ref
            .doc('world_0${world_id}')
            .collection('subsections')
            .doc('subsection_0${index}')
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) {
          worldSubsectionsNames.add(
            documentSnapshot['tittle'].toString(),
          );
          worldSubsectionsContent.add(documentSnapshot['content'].toString());
          worldSubsectionsDifficulty
              .add(documentSnapshot['difficulty'.toString()]);
          worldSubsectionsPoints.add(documentSnapshot['points'.toString()]);
          worldSubsectionsDuration.add(documentSnapshot['duration'.toString()]);
        });
      } catch (e) {
        print("Error obteniendo los nombres de los subsections");
        worldSubsectionsNames.add('Error');
        worldSubsectionsContent.add('Error');
        worldSubsectionsDifficulty.add('1');
        worldSubsectionsDuration.add('0h0min');
        worldSubsectionsPoints.add('0');
        userSubsection_progress = "0";
        userWorld_progress = "1";
      }
    }
    return [
      worldSubsectionsNames,
      worldSubsectionsContent,
      worldSubsectionsDifficulty,
      worldSubsectionsDuration,
      worldSubsectionsPoints,
      userSubsection_progress,
      userWorld_progress
    ];
  } else {
    for (int index = 1;
        index <= globals.worldIndexSubsections[world_index];
        index++) {
      try {
        final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        var user = await firebaseAuth.getUser();
        var user_ref = Firestore.instance.collection('users').document(user.id);
        var user_query = await user_ref.get();
        userSubsection_progress = user_query['subsection_progress'];
        userWorld_progress = user_query['world_progress'];
        var ref = Firestore.instance
            .collection('worlds')
            .document('world_0${world_id}')
            .collection('subsections')
            .document('subsection_0${index}');
        var query = await ref.get();
        worldSubsectionsNames.add(query['tittle'].toString());
        worldSubsectionsContent.add(query['content'].toString());
        worldSubsectionsDifficulty.add(query['difficulty'].toString());
        worldSubsectionsPoints.add(query['points'].toString());
        worldSubsectionsDuration.add(query['duration'].toString());
      } catch (e) {
        print("Error obteniendo los nombres de los subsections");
        worldSubsectionsNames.add('Error');
        worldSubsectionsContent.add('Error');
        worldSubsectionsDifficulty.add('1');
        worldSubsectionsDuration.add('0h0min');
        worldSubsectionsPoints.add('0');
        userSubsection_progress = "0";
        userWorld_progress = "1";
      }
    }
    return [
      worldSubsectionsNames,
      worldSubsectionsContent,
      worldSubsectionsDifficulty,
      worldSubsectionsDuration,
      worldSubsectionsPoints,
      userSubsection_progress,
      userWorld_progress
    ];
  }
}

class ContentSubsectionScreen extends StatefulWidget {
  final int world_index;
  final String world_name;

  ContentSubsectionScreen(
      {Key? key, required this.world_index, required this.world_name})
      : super(key: key);

  @override
  State<ContentSubsectionScreen> createState() =>
      _ContentSubsectionScreenState();
}

class _ContentSubsectionScreenState extends State<ContentSubsectionScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        FutureBuilder(
            future: getWorldSubsections(widget.world_index),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          globals.worldIndexSubsections[widget.world_index],
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          print(widget.world_index);
                          if (widget.world_index + 1 <
                              int.parse(snapshot.data[6])) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CustomWorldSubsectionHomeScreen(
                                      worldProgress: snapshot.data[6],
                                      subsectionProgress: snapshot.data[5],
                                      subsectionName: snapshot.data[0][index],
                                      actualWorld:
                                          widget.world_index.toString(),
                                      actualSubsection: index.toString(),
                                    )));
                          } else {
                            if (widget.world_index + 1 ==
                                    int.parse(snapshot.data[6]) &&
                                int.parse(snapshot.data[5]) >= index) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      CustomWorldSubsectionHomeScreen(
                                        worldProgress: snapshot.data[6],
                                        subsectionProgress: snapshot.data[5],
                                        subsectionName: snapshot.data[0][index],
                                        actualWorld:
                                            widget.world_index.toString(),
                                        actualSubsection: index.toString(),
                                      )));
                            } else {
                              if (widget.world_index + 1 == 7)
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CustomWorldSubsectionHomeScreen(
                                          worldProgress: snapshot.data[6],
                                          subsectionProgress: snapshot.data[5],
                                          subsectionName: snapshot.data[0]
                                              [index],
                                          actualWorld:
                                              widget.world_index.toString(),
                                          actualSubsection: index.toString(),
                                        )));
                              if (widget.world_index + 1 != 7)
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.info,
                                    title: "Información",
                                    titleColor: Colors.indigo,
                                    textColor: Colors.black,
                                    text:
                                        'No has desbloqueado esta subsección.',
                                    confirmBtnText: 'Aceptar');
                            }
                          }
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                  title: Text(
                                    snapshot.data[0][index],
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),
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
                                  subtitle: Text(
                                    snapshot.data[1][index],
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 5.0, bottom: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (index <= int.parse(snapshot.data[5]) &&
                                            (widget.world_index + 1 ==
                                                int.parse(snapshot.data[6])) ||
                                        (widget.world_index + 1 <
                                            int.parse(snapshot.data[6])) ||
                                        widget.world_index == 6)
                                      Column(
                                        children: [
                                          StepProgressIndicator(
                                              totalSteps: 5,
                                              currentStep: int.parse(
                                                  snapshot.data[2][index]),
                                              size: 36,
                                              selectedColor: Colors.amber,
                                              unselectedColor: Colors.white,
                                              customStep: (index, color, _) =>
                                                  color == Colors.amber
                                                      ? Container(
                                                          color: Colors.white,
                                                          child: Icon(
                                                            Icons.star,
                                                            color: color,
                                                          ))
                                                      : Container(
                                                          color: color,
                                                          child: Icon(
                                                            Icons.star_border,
                                                          ))),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Dificultad',
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    if (index > int.parse(snapshot.data[5]) &&
                                        (widget.world_index + 1 ==
                                            int.parse(snapshot.data[6])))
                                      Column(
                                        children: [
                                          StepProgressIndicator(
                                              totalSteps: 5,
                                              currentStep: int.parse(
                                                  snapshot.data[2][index]),
                                              size: 36,
                                              selectedColor: Colors.grey,
                                              unselectedColor: Colors.white,
                                              customStep: (index, color, _) =>
                                                  color == Colors.grey
                                                      ? Container(
                                                          color: Colors.white,
                                                          child: Icon(
                                                            Icons.star,
                                                            color: color,
                                                          ))
                                                      : Container(
                                                          color: color,
                                                          child: Icon(
                                                            Icons.star_border,
                                                          ))),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Dificultad',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    if (index <= int.parse(snapshot.data[5]) &&
                                            (widget.world_index + 1 ==
                                                int.parse(snapshot.data[6])) ||
                                        (widget.world_index + 1 <
                                                int.parse(snapshot.data[6])) &&
                                            widget.world_index < 6)
                                      Column(
                                        children: [
                                          CircularStepProgressIndicator(
                                            totalSteps: 10,
                                            currentStep: 10,
                                            selectedColor: Colors.indigo,
                                            unselectedColor: Colors.grey,
                                            padding: 0,
                                            height: 50,
                                            width: 50,
                                            child: Icon(
                                              Icons.military_tech_outlined,
                                              color: Colors.indigo,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '${snapshot.data[4][index]} pts',
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    if (index > int.parse(snapshot.data[5]) &&
                                        (widget.world_index + 1 ==
                                            int.parse(snapshot.data[6])))
                                      Column(
                                        children: [
                                          CircularStepProgressIndicator(
                                            totalSteps: 10,
                                            currentStep: 0,
                                            selectedColor: Colors.indigo,
                                            unselectedColor: Colors.grey,
                                            padding: 0,
                                            height: 50,
                                            width: 50,
                                            child: Icon(
                                              Icons.military_tech_outlined,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '${snapshot.data[4][index]} pts',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    if (index <= int.parse(snapshot.data[5]) &&
                                            (widget.world_index + 1 ==
                                                int.parse(snapshot.data[6])) ||
                                        (widget.world_index + 1 <
                                            int.parse(snapshot.data[6])) ||
                                        widget.world_index == 6)
                                      TextButton(
                                          onPressed: () {},
                                          child: const Icon(
                                            Icons
                                                .subdirectory_arrow_right_sharp,
                                            color: Colors.indigo,
                                          )),
                                    if (index > int.parse(snapshot.data[5]) &&
                                        (widget.world_index + 1 ==
                                            int.parse(snapshot.data[6])))
                                      TextButton(
                                          onPressed: () {},
                                          child: const Icon(
                                            Icons.lock,
                                            color: Colors.grey,
                                          )),
                                  ],
                                ),
                              ),
                              if (index <= int.parse(snapshot.data[5]) &&
                                      (widget.world_index + 1 ==
                                          int.parse(snapshot.data[6])) ||
                                  (widget.world_index + 1 <
                                      int.parse(snapshot.data[6])) ||
                                  widget.world_index == 6)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 10, left: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          snapshot.data[3][index],
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              if (index > int.parse(snapshot.data[5]) &&
                                  (widget.world_index + 1 ==
                                      int.parse(snapshot.data[6])))
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 10, left: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          snapshot.data[3][index],
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (BuildContext _, int __) =>
                          const Divider(),
                    ),
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
      ]),
    );
  }
}
