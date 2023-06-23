import 'package:flutter/material.dart';
import 'package:Openedu.IA/screens/screens.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Openedu.IA/constants/constants.dart' as globals;

Future setIcon(int selectedIcon) async {
  if (kIsWeb) {
    try {
      final _auth = web_auth.FirebaseAuth.instance;
      var user = await _auth.currentUser;
      web_firestore.CollectionReference ref =
          web_firestore.FirebaseFirestore.instance.collection('users');
      await ref.doc(user!.uid).update({'icon': 'user_0${selectedIcon}'});
    } catch (e) {
      return "Error";
    }
  } else {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      var ref = Firestore.instance.collection('users').document(user.id);
      await ref.update({'icon': 'user_0${selectedIcon}'});
    } catch (e) {
      return "Error";
    }
  }
}

// ignore: must_be_immutable
class CustomIconDialog extends StatefulWidget {
  final String rool;
  CustomIconDialog({Key? key, required this.rool}) : super(key: key);

  @override
  State<CustomIconDialog> createState() => _CustomIconDialogState();
}

class _CustomIconDialogState extends State<CustomIconDialog> {
  dynamic select_user_avatar = [
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
  ];
  int selected_user_index = 1;
  void get_selected_avatar(int index) {
    if (select_user_avatar[index] == Colors.indigo)
      select_user_avatar[index] = Colors.grey;
    else {
      for (int i = 0; i <= 5; i++) {
        select_user_avatar[i] = Colors.grey;
      }
      select_user_avatar[index] = Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(35),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo,
              blurRadius: 10.0,
            )
          ],
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Escoge tu avatar !',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: select_user_avatar[0],
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            AssetImage('assets/images/user/user_00.png'),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            get_selected_avatar(0);
                          }),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: select_user_avatar[1],
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            AssetImage('assets/images/user/user_01.png'),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            get_selected_avatar(1);
                          }),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: select_user_avatar[2],
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            AssetImage('assets/images/user/user_02.png'),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            get_selected_avatar(2);
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: select_user_avatar[3],
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            AssetImage('assets/images/user/user_03.png'),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            get_selected_avatar(3);
                          }),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: select_user_avatar[4],
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            AssetImage('assets/images/user/user_04.png'),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            get_selected_avatar(4);
                          }),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: select_user_avatar[5],
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            AssetImage('assets/images/user/user_05.png'),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            get_selected_avatar(5);
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(right: 15, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                        color: globals.pinkColor,
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('Cancelar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold))),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                      color: Colors.indigo,
                      onPressed: () {
                        for (int index = 0; index <= 5; index++) {
                          if (select_user_avatar[index] == Colors.indigo) {
                            selected_user_index = index;
                            break;
                          } else
                            selected_user_index = 1;
                        }
                        setIcon(selected_user_index);
                        if (widget.rool == "student") {
                          print("student");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomeStudentScreen()));
                        } else {
                          print("asdasdfasdf: " + widget.rool);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomeProfessorScreen()));
                        }
                      },
                      child: Text(
                        'Aceptar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
