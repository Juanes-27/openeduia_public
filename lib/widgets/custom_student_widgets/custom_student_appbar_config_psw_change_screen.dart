import 'package:Openedu.IA/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firedart/firedart.dart';
import 'package:quickalert/quickalert.dart';

void showInSnackBar(String value, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
}

Future changePsw(String password, BuildContext context) async {
  if (kIsWeb) {
    try {
      final _auth = web_auth.FirebaseAuth.instance;
      var user = await _auth.currentUser;
      await user?.updatePassword("${password}");
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginRegisterScreen()),
          (route) => false);
      showInSnackBar('Contraseña cambiada', context);
      _auth.signOut();
    } catch (e) {
      return showInSnackBar('Error: ${e}', context);
    }
  } else {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.changePassword(password);
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginRegisterScreen()),
          (route) => false);
      showInSnackBar('Contraseña cambiada', context);
      firebaseAuth.signOut();
    } catch (e) {
      return showInSnackBar('Error: ${e}', context);
    }
  }
}

class ConfigPasswordChangeScreen extends StatefulWidget {
  const ConfigPasswordChangeScreen({Key? key}) : super(key: key);

  @override
  State<ConfigPasswordChangeScreen> createState() =>
      _ConfigPasswordChangeScreenState();
}

class _ConfigPasswordChangeScreenState
    extends State<ConfigPasswordChangeScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmpassController = TextEditingController();
    final _formkey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Estás a punto de cambiar tu contraseña posteriormente tendrás que ingresar nuevamente.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: false,
                    controller: passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Nueva Contraseña',
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
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return "La contraseña no puede ser vacia";
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Por favor solicita una contraseña valida min 6 caracteres");
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {},
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: false,
                    controller: confirmpassController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Confirma tu Nueva Contraseña',
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
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return "La contraseña no puede ser vacia";
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Por favor solicita una contraseña valida min 6 caracteres");
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {},
                  ),
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
                      if (passwordController.text ==
                              confirmpassController.text &&
                          (passwordController.text.isNotEmpty ||
                              confirmpassController.text.isNotEmpty)) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: "¿Estás Seguro?",
                          text: "Estas por cambiar tu contraseña !",
                          confirmBtnText: "Estoy seguro",
                          onConfirmBtnTap: () async {
                            changePsw("${passwordController.text}", context);
                          },
                        );
                      } else {
                        await Future.delayed(Duration(seconds: 1));
                        if (confirmpassController.text !=
                            passwordController.text)
                          showInSnackBar('Contraseña no coincide', context);
                        if (confirmpassController.text.isEmpty ||
                            passwordController.text.isNotEmpty)
                          showInSnackBar(
                              'La contraseña no puede estar vacia', context);
                      }
                    },
                    child: Text(
                      "Cambia tu contraseña",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
