import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:Openedu.IA/screens/screens.dart';
import 'package:quickalert/quickalert.dart';

void _showInSnackBar(String value, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
}

Future addStudent(String studentId, BuildContext context, String groupName,
    String groupIndex) async {
  int current_students_count = 0;
  int students_new_count = 0;
  bool idValidator = false;
  if (kIsWeb) {
    try {
      final _auth = web_auth.FirebaseAuth.instance;
      var user = await _auth.currentUser;
      web_firestore.CollectionReference ref =
          web_firestore.FirebaseFirestore.instance.collection('users');
      try {
        await ref
            .doc(studentId)
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) {
          documentSnapshot['first_name'];
          idValidator = true;
        });
      } catch (e) {
        _showInSnackBar(
            "Error el Id no esta asociado a ningún estudiante", context);
        idValidator = false;
      }
      if (idValidator) {
        await ref
            .doc(user!.uid)
            .collection('students_groups')
            .doc('group_${int.parse(groupIndex) + 1}')
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) {
          current_students_count =
              int.parse(documentSnapshot['students_count']);
        });
        students_new_count = current_students_count + 1;
        await ref
            .doc(user.uid)
            .collection('students_groups')
            .doc('group_${int.parse(groupIndex) + 1}')
            .update({'students_count': students_new_count.toString()});
        await ref
            .doc(user.uid)
            .collection('students_groups')
            .doc('group_${int.parse(groupIndex) + 1}')
            .collection('students')
            .doc('student_${students_new_count.toString()}')
            .set({'id': studentId});
      }
    } catch (e) {
      _showInSnackBar("${e}", context);
    }
  } else {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      var ref = Firestore.instance.collection('users').document(studentId);
      try {
        var query = await ref.get();
        query['first_name'];
        idValidator = true;
      } catch (e) {
        _showInSnackBar(
            "Error el Id no esta asociado a ningún estudiante", context);
        idValidator = false;
      }
      if (idValidator) {
        var ref = Firestore.instance
            .collection('users')
            .document(user.id)
            .collection('students_groups')
            .document('group_${int.parse(groupIndex) + 1}');
        var query = await ref.get();
        current_students_count = int.parse(query['students_count']);
        students_new_count = current_students_count + 1;
        await Firestore.instance
            .collection('users')
            .document(user.id)
            .collection('students_groups')
            .document('group_${int.parse(groupIndex) + 1}')
            .update({'students_count': students_new_count.toString()});

        await Firestore.instance
            .collection('users')
            .document(user.id)
            .collection('students_groups')
            .document('group_${int.parse(groupIndex) + 1}')
            .collection('students')
            .document('student_${students_new_count.toString()}')
            .set({'id': studentId});
      }
    } catch (e) {
      _showInSnackBar("${e}", context);
    }
  }
  _showInSnackBar('Usuario Creado con exito.', context);
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => HomeProfessorScreen()));
}

class CustomGroupAddStudent extends StatelessWidget {
  final String groupName;
  final String groupIndex;
  const CustomGroupAddStudent(
      {Key? key, required this.groupName, required this.groupIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController addStudentController = TextEditingController();
    final _formkey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar Estudiante'),
        ),
        body: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        "Estás a punto de agregar un estudiante al grupo. Preguntale al estudiante el ID que lo identifica y copialo en el campo de texto.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: false,
                      controller: addStudentController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'ID del estudiante',
                        hintStyle: const TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.bold),
                        enabled: true,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.indigo),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      elevation: 5.0,
                      color: Colors.indigo,
                      height: 50,
                      onPressed: () async {
                        if (addStudentController.text.isNotEmpty) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            title: "¿Estás Seguro?",
                            text:
                                "Estas por agregar un nuevo estudiante al grupo.",
                            confirmBtnText: "Estoy seguro",
                            onConfirmBtnTap: () async {
                              addStudent("${addStudentController.text}",
                                  context, this.groupName, this.groupIndex);
                            },
                          );
                        } else {
                          _showInSnackBar(
                              'El ID no puede estar vacio', context);
                        }
                      },
                      child: Text(
                        "Agregar estudiante",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                  ]),
            )));
  }
}
