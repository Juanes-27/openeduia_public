import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Openedu.IA/constants/constants.dart' as globals;
import 'package:card_swiper/card_swiper.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:quickalert/quickalert.dart';
import '../../../screens/screens.dart';

Future getWorldChallenges(int world_index) async {
  int world_id = world_index + 1;
  String allowChallenge = "true";
  List<String> worldChallangesNames = [];
  List<String> worldChallangesDescription = [];
  List<String> worldChallengesDifficulty = [];
  List<String> worldChallengesRewards = [];
  if (world_id <= 2) {
    if (kIsWeb) {
      final _auth = web_auth.FirebaseAuth.instance;
      var user = await _auth.currentUser;
      web_firestore.CollectionReference ref =
          web_firestore.FirebaseFirestore.instance.collection('users');
      await ref
          .doc(user!.uid)
          .get()
          .then((web_firestore.DocumentSnapshot documentSnapshot) async {
        if (int.parse(documentSnapshot['challenges_count']) == 0 &&
            world_id == 2) {
          allowChallenge == "false";
        }
      });
      for (int numChallenges = 1;
          numChallenges <= globals.numberChallengesWorlds[world_index];
          numChallenges++) {
        try {
          web_firestore.CollectionReference ref =
              web_firestore.FirebaseFirestore.instance.collection('worlds');
          await ref
              .doc('world_0${world_id}')
              .collection('challenges')
              .doc(
                  'challenge_0${globals.numberChallengesWorlds[numChallenges]}')
              .get()
              .then((web_firestore.DocumentSnapshot documentSnapshot) {
            worldChallangesNames.add(documentSnapshot['tittle'].toString());
            worldChallangesDescription
                .add(documentSnapshot['description'].toString());
            worldChallengesDifficulty
                .add(documentSnapshot['difficulty'].toString());
            worldChallengesRewards.add(documentSnapshot['reward'].toString());
          });
        } catch (e) {
          worldChallangesNames.add('Error accediendo a la info del desafio');
          worldChallangesDescription.add('Sin descripción');
          worldChallengesDifficulty.add('0');
          worldChallengesRewards.add('0');
        }
      }
      print(allowChallenge);
      return [
        worldChallangesNames,
        worldChallangesDescription,
        worldChallengesDifficulty,
        worldChallengesRewards,
        allowChallenge
      ];
    } else {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      var ref = Firestore.instance.collection('users').document(user.id);
      var userInfo = await ref.get();
      if (userInfo['challenges_count'] == "0" && world_id == 2) {
        allowChallenge = "false";
      }
      for (int numChallenges = 1;
          numChallenges <= globals.numberChallengesWorlds[world_index];
          numChallenges++) {
        try {
          var ref = Firestore.instance
              .collection('worlds')
              .document('world_0${world_id}')
              .collection('challenges')
              .document(
                  'challenge_0${globals.numberChallengesWorlds[numChallenges]}');
          var query = await ref.get();
          worldChallangesNames.add(query['tittle'].toString());
          worldChallangesDescription.add(query['description'].toString());
          worldChallengesDifficulty.add(query['difficulty'].toString());
          worldChallengesRewards.add(query['reward'].toString());
        } catch (e) {
          worldChallangesNames.add('Error accediendo a la info del desafio');
          worldChallangesDescription.add('Sin descripción');
          worldChallengesDifficulty.add('0');
          worldChallengesRewards.add('0');
        }
      }
      print(allowChallenge);
      return [
        worldChallangesNames,
        worldChallangesDescription,
        worldChallengesDifficulty,
        worldChallengesRewards,
        allowChallenge
      ];
    }
  }
}

class ChallengesWorldScreen extends StatelessWidget {
  final int world_index;
  ChallengesWorldScreen({Key? key, required this.world_index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          if (this.world_index <= 1)
            FutureBuilder(
                future: getWorldChallenges(this.world_index),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: width,
                      height: height - 200,
                      child: GestureDetector(
                        child: Swiper(
                          itemCount:
                              globals.numberChallengesWorlds[world_index],
                          itemBuilder: (context, index) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    print(index);
                                    if (index == 0 && this.world_index == 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PacManWorld1HomeScreen()));
                                    }
                                    if (index == 0 &&
                                        this.world_index == 1 &&
                                        snapshot.data[4] == "true") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  HomeScreenMemoryGame()));
                                    }
                                    if (index == 0 &&
                                        this.world_index == 1 &&
                                        snapshot.data[4] == "false") {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.info,
                                        title: "No puedes acceder",
                                        text:
                                            "Tienes que completar el challenge anterior para desbloquear este.",
                                        confirmBtnText: "Ok",
                                      );
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      if (kIsWeb)
                                        Container(
                                          width: width,
                                          height: 220,
                                          child: FadeInImage(
                                            image: AssetImage(
                                              'assets/worlds/challenges/challenge_${this.world_index + 1}.jpg',
                                            ),
                                            placeholder: const AssetImage(
                                              'assets/icon/loading.gif',
                                            ),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      if (!kIsWeb)
                                        if (Platform.isAndroid ||
                                            Platform.isIOS)
                                          Container(
                                            width: width,
                                            height: 220,
                                            child: FadeInImage(
                                              image: AssetImage(
                                                'assets/worlds/challenges/challenge_${this.world_index + 1}.jpg',
                                              ),
                                              placeholder: const AssetImage(
                                                'assets/icon/loading.gif',
                                              ),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                      if (!kIsWeb)
                                        if (Platform.isFuchsia ||
                                            Platform.isLinux ||
                                            Platform.isMacOS ||
                                            Platform.isWindows)
                                          Container(
                                            width: width,
                                            height: 220,
                                            child: FadeInImage(
                                              image: AssetImage(
                                                'assets/worlds/challenges/challenge_${this.world_index + 1}.jpg',
                                              ),
                                              placeholder: const AssetImage(
                                                'assets/icon/loading.gif',
                                              ),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        snapshot.data[0][index]
                                            .toString()
                                            .toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: globals.pinkColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 25),
                                        child: Text(
                                          snapshot.data[1][index],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              color: Colors.deepPurple[900],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 25),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'DIFICULTAD',
                                              style: TextStyle(
                                                  color: globals.pinkColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            StepProgressIndicator(
                                                totalSteps: 5,
                                                currentStep: int.parse(
                                                    snapshot.data[2][index]),
                                                size: 40,
                                                selectedColor: Colors.indigo,
                                                unselectedColor: Colors.white,
                                                customStep: (index, color, _) {
                                                  color == Colors.indigo;
                                                  return color == Colors.indigo
                                                      ? Container(
                                                          child: Icon(
                                                          Icons
                                                              .local_convenience_store_outlined,
                                                          color: color,
                                                          size: 25,
                                                        ))
                                                      : Container(
                                                          child: Icon(
                                                          Icons
                                                              .local_convenience_store_outlined,
                                                          color: Colors.grey,
                                                        ));
                                                }),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 25),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'RECOMPENSAS',
                                              style: TextStyle(
                                                  color: globals.pinkColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            StepProgressIndicator(
                                                totalSteps: 5,
                                                currentStep: int.parse(
                                                    snapshot.data[3][index]),
                                                size: 50,
                                                selectedColor: Colors.indigo,
                                                unselectedColor: Colors.white,
                                                customStep: (index, color, _) {
                                                  color == Colors.indigo;
                                                  return color == Colors.indigo
                                                      ? Container(
                                                          child: Icon(
                                                          Icons
                                                              .monetization_on_outlined,
                                                          color: color,
                                                        ))
                                                      : Container(
                                                          child: Icon(
                                                          Icons
                                                              .monetization_on_outlined,
                                                          color: Colors.grey,
                                                        ));
                                                }),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          indicatorLayout: PageIndicatorLayout.NONE,
                          autoplay: false,
                          pagination: const SwiperPagination(),
                          control: const SwiperControl(),
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
          if (this.world_index > 1)
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(
                'Este mundo no tienen challenges habilitados por el momento.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
        ],
      ),
    );
  }
}
