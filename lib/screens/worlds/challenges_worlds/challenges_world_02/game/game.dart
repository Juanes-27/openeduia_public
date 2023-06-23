import 'dart:async';
import 'dart:io';
import 'package:Openedu.IA/screens/screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;

Future addChallenge(BuildContext context) async {
  try {
    if (kIsWeb) {
      final _auth = web_auth.FirebaseAuth.instance;
      var user = await _auth.currentUser;
      web_firestore.CollectionReference ref =
          web_firestore.FirebaseFirestore.instance.collection('users');
      await ref
          .doc(user!.uid)
          .get()
          .then((web_firestore.DocumentSnapshot documentSnapshot) async {
        if (int.parse(documentSnapshot['challenges_count']) == 0) {
          await ref.doc(user.uid).update({
            'challenges_count': '1',
          });
        } else {
          await ref.doc(user.uid).update({
            'challenges_count': '2',
          });
        }
      });
    } else {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      var ref = Firestore.instance.collection('users').document(user.id);
      var userInfo = await ref.get();
      if (int.parse(userInfo['challenges_count']) == 0) {
        await ref.update({
          'challenges_count': '1',
        });
      } else {
        await ref.update({
          'challenges_count': '2',
        });
      }
    }
  } catch (e) {
    showInSnackBar('${e}', context);
  }
}

class Game extends StatefulWidget {
  Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final GameLogic _game = GameLogic();

  var levelForCardCount = 0;
  var tries = 0;
  var score = 0;
  var axisNumber = 4;
  late Timer timer;
  int startTime = 60;
  String level = '';
  var complete = 0;
  void startTimer(BuildContext context) {
    if (startTime == 0) {}
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      if (startTime == 0) {
        timer.cancel();
        _showDialog(context, 'Final del juego', 'Tu puntuación fue de: $score');
      } else {
        setState(() {
          startTime--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _game.initGame(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        timer.cancel();
        // show the confirm dialog
        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Seguro que quiere salir de la partida?'),
                  actions: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo),
                        onPressed: () {
                          willLeave = true;
                          Navigator.of(context).pop();
                        },
                        child: const Text('Si')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          startTimer(context);
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ));
        return willLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
        ),
        backgroundColor: Colors.indigo,
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                board('Tiempo', '$startTime'),
                board('Puntaje', '$score'),
                board('Movimiento', '$tries')
              ],
            ),
            if (kIsWeb)
              SizedBox(
                height: screenHeight - 150,
                width: screenHeight,
                child: GridView.builder(
                    itemCount: _game.cardsImg!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _game.axiCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () async {
                            setState(() {
                              tries++;

                              _game.cardsImg![index] = _game.card_list[index];

                              _game.matchCheck
                                  .add({index: _game.card_list[index]});

                              if (_game.matchCheck.length == 2) {
                                if (_game.matchCheck[0].values.first ==
                                    _game.matchCheck[1].values.first) {
                                  score += 100;
                                  complete += 1;

                                  _game.matchCheck.clear();
                                  if (complete * 2 == _game.cardCount) {
                                    _showDialog(context, 'Ganaste',
                                        'Tu puntuación fue de: $score');
                                    timer.cancel();
                                  }
                                } else {
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    setState(() {
                                      _game.cardsImg![_game.matchCheck[0].keys
                                          .first] = _game.hiddenCard;
                                      _game.cardsImg![_game.matchCheck[1].keys
                                          .first] = _game.hiddenCard;

                                      _game.matchCheck.clear();
                                    });
                                  });
                                }
                              }
                            });

                            // _game.matchCheck
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: AssetImage(_game.cardsImg![index]),
                                    fit: BoxFit.cover)),
                          ));
                    }),
              ),
            if (!kIsWeb)
              if (Platform.isLinux || Platform.isMacOS || Platform.isWindows)
                SizedBox(
                  height: screenHeight - 150,
                  width: screenHeight,
                  child: GridView.builder(
                      itemCount: _game.cardsImg!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _game.axiCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                tries++;

                                _game.cardsImg![index] = _game.card_list[index];

                                _game.matchCheck
                                    .add({index: _game.card_list[index]});

                                if (_game.matchCheck.length == 2) {
                                  if (_game.matchCheck[0].values.first ==
                                      _game.matchCheck[1].values.first) {
                                    score += 100;
                                    complete += 1;

                                    _game.matchCheck.clear();
                                    if (complete * 2 == _game.cardCount) {
                                      _showDialog(context, 'Ganaste',
                                          'Tu puntuación fue de: $score');
                                      timer.cancel();
                                    }
                                  } else {
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      setState(() {
                                        _game.cardsImg![_game.matchCheck[0].keys
                                            .first] = _game.hiddenCard;
                                        _game.cardsImg![_game.matchCheck[1].keys
                                            .first] = _game.hiddenCard;

                                        _game.matchCheck.clear();
                                      });
                                    });
                                  }
                                }
                              });

                              // _game.matchCheck
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: AssetImage(_game.cardsImg![index]),
                                      fit: BoxFit.cover)),
                            ));
                      }),
                ),
            if (!kIsWeb)
              if (Platform.isAndroid || Platform.isIOS)
                SizedBox(
                  height: screenWidth,
                  width: screenWidth,
                  child: GridView.builder(
                      itemCount: _game.cardsImg!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _game.axiCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                tries++;

                                _game.cardsImg![index] = _game.card_list[index];

                                _game.matchCheck
                                    .add({index: _game.card_list[index]});

                                if (_game.matchCheck.length == 2) {
                                  if (_game.matchCheck[0].values.first ==
                                      _game.matchCheck[1].values.first) {
                                    score += 100;
                                    complete += 1;

                                    _game.matchCheck.clear();
                                    if (complete * 2 == _game.cardCount) {
                                      _showDialog(context, 'Ganaste',
                                          'Tu puntuación fue de: $score');
                                      timer.cancel();
                                    }
                                  } else {
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      setState(() {
                                        _game.cardsImg![_game.matchCheck[0].keys
                                            .first] = _game.hiddenCard;
                                        _game.cardsImg![_game.matchCheck[1].keys
                                            .first] = _game.hiddenCard;

                                        _game.matchCheck.clear();
                                      });
                                    });
                                  }
                                }
                              });

                              // _game.matchCheck
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: AssetImage(_game.cardsImg![index]),
                                      fit: BoxFit.cover)),
                            ));
                      }),
                ),
          ]),
        ),
      ),
    );
  }
}

void _showDialog(BuildContext context, String title, String info) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(info),
          actions: [
            TextButton(
              child: Text('Ir a inicio'),
              onPressed: () {
                if (title == "Ganaste") addChallenge(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomeStudentScreen();
                }));
              },
            )
          ],
        );
      });
}
