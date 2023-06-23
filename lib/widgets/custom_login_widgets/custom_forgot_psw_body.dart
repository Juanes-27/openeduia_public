import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:Openedu.IA/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firedart/firedart.dart';
import 'package:quickalert/quickalert.dart';

Future resetPassword(BuildContext context, String email) async {
  if (kIsWeb) {
    try {
      final _auth = web_auth.FirebaseAuth.instance;
      await _auth.sendPasswordResetEmail(email: email);
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginRegisterScreen()),
          (route) => false);
      showInSnackBar(
          'Revisa tu correo para reestablecer tu contraseña', context);
    } catch (e) {
      showInSnackBar('Error: ${e}', context);
    }
  } else {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.resetPassword(email);
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginRegisterScreen()),
          (route) => false);
      showInSnackBar(
          'Revisa tu correo para reestablecer tu contraseña', context);
    } catch (e) {
      showInSnackBar('Error: ${e}', context);
    }
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  void setLogInScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const LoginRegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Center(
              child: Text(
                'OpenEduIA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    customshowDialog(context);
                  },
                  icon: const Icon(Icons.info))
            ]),
        body: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.only(top: 5, right: 15, left: 15),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Por favor ingresa tu correo electrónico para enviarte las instrucciones a seguir para reestablecer tu contraseña.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Correo Electrónico',
                  hintStyle: const TextStyle(
                      color: Colors.indigo, fontWeight: FontWeight.bold),
                  enabled: true,
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
                onChanged: (value) {},
                keyboardType: TextInputType.emailAddress,
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
                  if (emailController.text.isNotEmpty &&
                      emailController.text.contains('@')) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      title: "¿Estás Seguro?",
                      text:
                          "Este proceso envia un link de correo electrónico para recuperar tu cuenta.",
                      confirmBtnText: "Estoy seguro",
                      onConfirmBtnTap: () async {
                        resetPassword(context, emailController.text);
                      },
                    );
                  } else {
                    await Future.delayed(Duration(seconds: 1));
                    showInSnackBar(
                        'El correo electrónico es invalido', context);
                  }
                },
                child: Text(
                  "Reestablecer Contraseña",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿Quieres volver?',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => setLogInScreen(context),
                    child: const Text(
                      'Toca Aquí',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
        )));
  }
}
