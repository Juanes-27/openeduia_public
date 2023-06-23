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

Future changeGroupName(String groupNewName, BuildContext context,
    String groupName, String groupIndex) async {
  if (kIsWeb) {
    try {
      final _auth = web_auth.FirebaseAuth.instance;
      var user = await _auth.currentUser;
      web_firestore.CollectionReference ref =
          web_firestore.FirebaseFirestore.instance.collection('users');
      await ref
          .doc(user!.uid)
          .collection('students_groups')
          .doc('group_${int.parse(groupIndex) + 1}')
          .update({'name': groupNewName});
    } catch (e) {
      return _showInSnackBar('Error: ${e}', context);
    }
  } else {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      var ref = Firestore.instance
          .collection('users')
          .document(user.id)
          .collection('students_groups')
          .document('group_${int.parse(groupIndex) + 1}');

      await ref.update({'name': groupNewName});
    } catch (e) {
      return _showInSnackBar('Error: ${e}', context);
    }
  }

  await Future.delayed(Duration(seconds: 1));
  _showInSnackBar('Nombre cambiado con exito.', context);
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => HomeProfessorScreen()));
}

class CustomConfigGroupChangeName extends StatelessWidget {
  final String groupName;
  final String groupIndex;
  const CustomConfigGroupChangeName(
      {Key? key, required this.groupName, required this.groupIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController groupNewName = TextEditingController();
    final _formkey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          title: Text("Cambio de Nombre"),
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
                        "Estás a punto de cambiar el nombre del grupo.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: false,
                      controller: groupNewName,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Nuevo nombre de grupo.',
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
                        if (groupNewName.text.isNotEmpty) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            title: "¿Estás Seguro?",
                            text: "Estas por cambiar el nombre del grupo.",
                            confirmBtnText: "Estoy seguro",
                            onConfirmBtnTap: () async {
                              changeGroupName("${groupNewName.text}", context,
                                  this.groupName, this.groupIndex);
                            },
                          );
                        } else {
                          _showInSnackBar(
                              'El nombre no puede estar vacio', context);
                        }
                      },
                      child: Text(
                        "Cambiar nombre",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                  ]),
            )));
  }
}
