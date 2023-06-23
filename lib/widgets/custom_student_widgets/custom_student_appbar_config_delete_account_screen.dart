import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Openedu.IA/screens/screens.dart';
import 'package:quickalert/quickalert.dart';

Future deleteAccount(BuildContext context) async {
  if (kIsWeb) {
    try {
      final _auth = web_auth.FirebaseAuth.instance;
      var user = await _auth.currentUser;
      await user?.delete();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginRegisterScreen()),
          (route) => false);
      showInSnackBar('Cuenta Eliminada', context);
    } catch (e) {
      showInSnackBar('Error: ${e}', context);
    }
  } else {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.deleteAccount();
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginRegisterScreen()),
          (route) => false);
      showInSnackBar('Cuenta Eliminada', context);
    } catch (e) {
      showInSnackBar('Error: ${e}', context);
    }
  }
}

class ConfigDeleteAccountScreen extends StatelessWidget {
  const ConfigDeleteAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController changeAccountController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
        child: Column(children: [
          Form(
              child: Column(
            children: [
              Text(
                "Estás a punto de eliminar tu cuenta, recuerda que este proceso es inreversible.",
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
                "En el siguiente apartado digita la siguiente frase 'elimina mi cuenta' sin comillas, para eliminar tu cuenta.",
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
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
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
              if (changeAccountController.text == "elimina mi cuenta") {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  title: "¿Estás Seguro?",
                  text:
                      "Este proceso elimina tu cuenta y no puedes recuperar tus datos.",
                  confirmBtnText: "Estoy seguro",
                  onConfirmBtnTap: () async {
                    deleteAccount(context);
                  },
                );
              } else {
                await Future.delayed(Duration(seconds: 1));
                if (changeAccountController.text != "deseo cambiar mi cuenta")
                  showInSnackBar('La frase no coincide', context);
              }
            },
            child: Text(
              "Elimina mi Cuenta",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
        ]),
      ),
    );
  }
}
