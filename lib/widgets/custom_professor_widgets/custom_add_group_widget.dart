import 'package:Openedu.IA/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomAddGroup extends StatefulWidget {
  const CustomAddGroup({Key? key}) : super(key: key);

  @override
  State<CustomAddGroup> createState() => _CustomAddGroupState();
}

class _CustomAddGroupState extends State<CustomAddGroup> {
  final TextEditingController groupNameController = TextEditingController();
  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 5, bottom: 10),
              child: Text(
                "En este sección podrás crear un nuevo grupo de estudio.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              )),
          TextFormField(
            controller: groupNameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Nombre del Grupo',
              hintStyle: const TextStyle(
                  color: Colors.indigo, fontWeight: FontWeight.bold),
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.indigo),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.indigo),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: MaterialButton(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              elevation: 5.0,
              height: 50,
              onPressed: () async {
                if (groupNameController.text.isNotEmpty) {
                  createGroup(context, groupNameController.text);
                } else {
                  showInSnackBar(
                      'El nombre del grupo no puede estar vacio.', context);
                }
              },
              color: Colors.indigo,
              child: const Text(
                "Crear Grupo ",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future createGroup(BuildContext context, String group_name) async {
  String groups_count = "0";

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
        groups_count = documentSnapshot['groups_count'].toString();
      });
      if (int.parse(groups_count) > 9) {
        showInSnackBar('No puedes crear más de 9 grupos por cuenta.', context);
      } else {
        await ref
            .doc(user.uid)
            .collection('students_groups')
            .doc('group_${int.parse(groups_count) + 1}')
            .set({
          'name': group_name,
          'students_count': '0',
        });
        await ref
            .doc(user.uid)
            .update({"groups_count": int.parse(groups_count) + 1});
      }
    } catch (e) {
      showInSnackBar('Error-> ${e}', context);
    }
  } else {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      var ref = Firestore.instance.collection('users').document(user.id);
      var query = await ref.get();
      groups_count = query['groups_count'].toString();
      if (int.parse(groups_count) > 9) {
        showInSnackBar('No puedes crear más de 9 grupos por cuenta.', context);
      } else {
        ref
            .collection('students_groups')
            .document('group_${int.parse(groups_count) + 1}')
            .set({
          'name': group_name,
          'students_count': '0',
        });
        ref.update({"groups_count": int.parse(groups_count) + 1});
      }
    } catch (e) {
      showInSnackBar('Error-> ${e}', context);
    }
  }

  await Future.delayed(Duration(seconds: 1));
  showInSnackBar('Grupo creado con exito.', context);
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => HomeProfessorScreen()));
}
