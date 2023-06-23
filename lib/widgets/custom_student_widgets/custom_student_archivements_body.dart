import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Openedu.IA/constants/constants.dart' as globals;
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CustomStudentArchivementsBody extends StatelessWidget {
  const CustomStudentArchivementsBody({Key? key}) : super(key: key);
  Future getChallengesInfo(BuildContext context) async {
    String challenge_count = "0";
    int _rewards_count = 0;
    String rewards_count = "0";
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
          challenge_count = documentSnapshot['challenges_count'].toString();
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
        challenge_count = query['challenges_count'].toString();
        world_progress = query['world_progress'].toString();
        subsections_progress = query['subsection_progress'].toString();
      } catch (e) {
        showInSnackBar('Error-> ${e}', context);
      }
    }
    if (challenge_count != "0") {
      for (int index = 1; index <= int.parse(challenge_count); index++) {
        _rewards_count += globals.numberRewardsByChallengeWorlds[index - 1];
      }
      rewards_count = _rewards_count.toString();
    }
    return [
      challenge_count,
      rewards_count,
      world_progress,
      subsections_progress
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomStudentAppBarHome(),
              FutureBuilder(
                  future: getChallengesInfo(context),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      int totalPoints = globals.sumTwoDimensionalList(
                          globals.valuesPointsSubsectionsperWorld,
                          int.parse(snapshot.data[2]) - 1,
                          int.parse(snapshot.data[3]));
                      print(
                          "Points: ${totalPoints}, current world: ${int.parse(snapshot.data[2]) - 1}, current subsection: ${int.parse(snapshot.data[3])}");
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Desafíos Completados",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              if (int.parse(snapshot.data[0].toString()) > 0)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 5, top: 10),
                                  child: Text(
                                    "En este sección encontrarás información sobre los desafíos que has completado.",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: globals.pinkColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              SizedBox(
                                height: 15,
                              ),
                              if (int.parse(snapshot.data[0].toString()) > 0)
                                SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                      itemCount: int.parse(
                                          snapshot.data[0].toString()),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) =>
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.indigo,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            height: 150,
                                            width: 150,
                                            margin: EdgeInsets.all(10),
                                            child: Center(
                                              child: Text(
                                                "${globals.namesChallenges[index]}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                      "No has completado ningún desafío por el momento.",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                              if (int.parse(snapshot.data[0].toString()) > 0)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    height: 50,
                                    width: size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: StepProgressIndicator(
                                        totalSteps: globals.totalChallenges,
                                        currentStep:
                                            int.parse(snapshot.data[0]),
                                        size: 40,
                                        selectedColor: Colors.indigo,
                                        unselectedColor: Colors.grey,
                                        roundedEdges: Radius.circular(10),
                                        customStep: (index, color, _) =>
                                            color == Colors.indigo
                                                ? Container(
                                                    width: 50,
                                                    color: color,
                                                    child: Icon(
                                                      Icons.military_tech,
                                                      color: Colors.white,
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
                                    ),
                                  ),
                                ),
                              if (int.parse(snapshot.data[0].toString()) > 0 &&
                                  int.parse(snapshot.data[0].toString()) != 1)
                                Text(
                                  "Vas ${snapshot.data[0]} desafíos completados de ${globals.totalChallenges}.",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              if (int.parse(snapshot.data[0].toString()) > 0 &&
                                  int.parse(snapshot.data[0].toString()) == 1)
                                Text(
                                  "Vas ${snapshot.data[0]} desafio completado de ${globals.totalChallenges}.",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Recompensas obtenidas",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              if (int.parse(snapshot.data[0].toString()) > 0)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 5, top: 5),
                                  child: Text(
                                    "En este sección encontrarás información sobre las recompensas obtenidas.",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: globals.pinkColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              if (int.parse(snapshot.data[0].toString()) == 0)
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                      "No tienes ninguna recompensa por el momento.",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                              SizedBox(
                                height: 15,
                              ),
                              if (int.parse(snapshot.data[0].toString()) > 0)
                                Row(
                                  children: [
                                    CircularStepProgressIndicator(
                                      totalSteps: globals.rewardsTotalPoints,
                                      currentStep: int.parse(
                                          snapshot.data[1].toString()),
                                      selectedColor: Colors.indigo,
                                      unselectedColor: Colors.grey,
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
                                        "Total de Recompensas ${snapshot.data[1]}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ],
                                ),
                              SizedBox(
                                height: 5,
                              ),
                              if (int.parse(snapshot.data[0].toString()) > 0)
                                Text(
                                  "Vas ${snapshot.data[1]} recompensas obtenidas de ${globals.rewardsTotalPoints}.",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Puntos totales",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, bottom: 10),
                                child: Text(
                                  "En este sección encontrarás información sobre los puntos obtenidos al desbloquear una subsección.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: globals.pinkColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, bottom: 10),
                                child: StepProgressIndicator(
                                  totalSteps: globals.totalpointsSubsections,
                                  currentStep: totalPoints,
                                  size: 8,
                                  padding: 0,
                                  selectedColor: Colors.indigo,
                                  unselectedColor: Colors.grey,
                                  roundedEdges: Radius.circular(10),
                                  selectedGradientColor: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.indigo, Colors.indigo],
                                  ),
                                  unselectedGradientColor: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.grey, Colors.grey],
                                  ),
                                ),
                              ),
                              Text(
                                "Vas ${totalPoints} puntos de ${globals.totalpointsSubsections}.",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              Text(
                                "Progreso de Mundos",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (int.parse(snapshot.data[0].toString()) > 0)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 5, bottom: 10),
                                  child: Text(
                                    "En este sección encontrarás tu progreso sobre tus mundos cursados.",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: globals.pinkColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  height: 50,
                                  width: size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: StepProgressIndicator(
                                      totalSteps: globals.numberWorlds - 1,
                                      currentStep: int.parse(snapshot.data[2]),
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
                                                    Icons.emoji_flags,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                )
                                              : Container(
                                                  width: 50,
                                                  color: color,
                                                  child: Icon(
                                                    Icons.public_off_outlined,
                                                    size: 20,
                                                  ),
                                                ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "Estás en el mundo ${globals.worldsNames[int.parse(snapshot.data[2]) - 1]}.",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              Text(
                                "Progreso de Subsección",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, bottom: 10),
                                child: Text(
                                  "En este sección encontrarás información sobre tu progreso en la subsección del mundo que estás cursando.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: globals.pinkColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  height: 50,
                                  width: size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: StepProgressIndicator(
                                      totalSteps: globals.worldIndexSubsections[
                                          int.parse(snapshot.data[2]) - 1],
                                      currentStep:
                                          int.parse(snapshot.data[3]) + 1,
                                      selectedColor: Colors.indigo,
                                      unselectedColor: Colors.grey,
                                      roundedEdges: Radius.circular(10),
                                      size: 40,
                                      customStep: (index, color, _) => color ==
                                              Colors.indigo
                                          ? Container(
                                              width: 50,
                                              color: color,
                                              child: Icon(
                                                Icons.event_available_outlined,
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
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  "Estás cursando la subsección de ${globals.subsectionsName[int.parse(snapshot.data[2]) - 1][int.parse(snapshot.data[3])]} del mundo ${globals.worldsNames[int.parse(snapshot.data[2]) - 1]}.",
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
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            height: size.height / 4,
                          ),
                          Text(
                            'Cargando ...',
                            style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                                fontSize: 36),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            color: Colors.indigo,
                          )
                        ],
                      );
                    }
                  })
            ],
          ),
        ));
  }
}
