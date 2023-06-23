import 'package:Openedu.IA/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firedart/firedart.dart';
import 'package:quickalert/quickalert.dart';

import '../widgets.dart';

Future changeroolAccount(BuildContext context) async {
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
        if (documentSnapshot['rool'].toString() == "student") {
          ref.doc(user.uid).set({
            'email': documentSnapshot["email"].toString(),
            'rool': "teacher",
            'first_name': documentSnapshot["first_name"].toString(),
            'last_name': documentSnapshot["last_name"].toString(),
            'icon': documentSnapshot["icon"].toString(),
            'groups_count': '0',
          });
        } else {
          ref.doc(user.uid).set({
            'email': documentSnapshot["email"].toString(),
            'rool': "student",
            'first_name': documentSnapshot["first_name"].toString(),
            'last_name': documentSnapshot["last_name"].toString(),
            'icon': documentSnapshot["icon"].toString(),
            'world_progress': '1',
            'subsection_progress': '0',
            'challenges_count': '0',
          });
        }
      });
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginRegisterScreen()),
          (route) => false);
      _auth.signOut();
      showInSnackBar('Cuenta cambiada', context);
    } catch (e) {
      showInSnackBar('Error: ${e}', context);
    }
  } else {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      var ref = Firestore.instance.collection('users').document(user.id);
      var _ref = Firestore.instance.collection('users');
      var query = await ref.get();
      if (query['rool'].toString() == "student") {
        await _ref.document(user.id).set({
          'email': query['email'].toString(),
          'rool': "teacher",
          'first_name': query['first_name'].toString(),
          'last_name': query['last_name'].toString(),
          'icon': query['icon'].toString(),
          'groups_count': '0',
        });
      } else {
        print("account ${query['rool'.toString()]}");
        await _ref.document(user.id).set({
          'email': query['email'].toString(),
          'rool': "student",
          'first_name': query['first_name'].toString(),
          'last_name': query['last_name'].toString(),
          'icon': query['icon'].toString(),
          'world_progress': '1',
          'subsection_progress': '0',
          'challenges_count': '0',
        });
      }
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginRegisterScreen()),
          (route) => false);
      firebaseAuth.signOut();
      showInSnackBar('Cuenta Cambiada', context);
    } catch (e) {
      showInSnackBar('Error: ${e}', context);
    }
  }
}

class ConfigAccountChangeScreen extends StatelessWidget {
  const ConfigAccountChangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController changeAccountController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin:
              const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
          child: Column(children: [
            Form(
                child: Column(
              children: [
                Text(
                  "Estás a punto de cambiar tu tipo de cuenta, ten en cuenta que todo tu progreso será eliminado. (Si tienes una cuenta como profesor todos los grupos creados serán eliminados)",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "En el siguiente apartado digita la siguiente frase 'deseo cambiar mi cuenta' sin comillas, para poder cambiar el tipo de tu cuenta.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: false,
                  controller: changeAccountController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Ingresa la Frase',
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
                  onChanged: (value) {},
                ),
              ],
            )),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              elevation: 5.0,
              color: Colors.indigo,
              height: 50,
              onPressed: () async {
                if (changeAccountController.text == "deseo cambiar mi cuenta") {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    title: "¿Estás Seguro?",
                    text: "Estas por cambiar tu tipo de cuenta!.",
                    confirmBtnText: "Estoy seguro",
                    onConfirmBtnTap: () async {
                      changeroolAccount(context);
                    },
                  );
                } else {
                  await Future.delayed(Duration(seconds: 1));
                  if (changeAccountController.text != "deseo cambiar mi cuenta")
                    showInSnackBar('La frase no coincide', context);
                }
              },
              child: Text(
                "Cambio de Cuenta",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
