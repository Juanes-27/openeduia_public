import 'package:flutter/material.dart';
import 'package:Openedu.IA/screens/screens.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;

class PacManCongratulationDialogScreen extends StatelessWidget {
  const PacManCongratulationDialogScreen({Key? key}) : super(key: key);

  static show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const PacManCongratulationDialogScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(color: Colors.indigo);
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Felicidades!',
                style: textStyle.copyWith(
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Gracias por completar este desafio.',
                style: textStyle,
              ),
              const SizedBox(height: 20),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  overlayColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.2),
                  ),
                  side: MaterialStateProperty.all(
                    const BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  try {
                    if (kIsWeb) {
                      final _auth = web_auth.FirebaseAuth.instance;
                      var user = await _auth.currentUser;
                      web_firestore.CollectionReference ref = web_firestore
                          .FirebaseFirestore.instance
                          .collection('users');
                      await ref.doc(user!.uid).get().then(
                          (web_firestore.DocumentSnapshot
                              documentSnapshot) async {
                        if (int.parse(documentSnapshot['challenges_count']) ==
                            0) {
                          await ref.doc(user.uid).update({
                            'challenges_count': '1',
                          });
                        } else {
                          await ref.doc(user.uid).update({
                            'challenges_count': '2',
                          });
                        }
                      });
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeStudentScreen();
                      }), (route) => false);
                    } else {
                      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                      var user = await firebaseAuth.getUser();
                      var ref = Firestore.instance
                          .collection('users')
                          .document(user.id);
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
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeStudentScreen();
                      }), (route) => false);
                    }
                  } catch (e) {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeStudentScreen();
                    }), (route) => false);
                  }
                },
                child: Text(
                  'Vuelve al menú principal',
                  style: textStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
