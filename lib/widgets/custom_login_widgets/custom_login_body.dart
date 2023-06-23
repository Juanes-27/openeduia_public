import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:Openedu.IA/screens/screens.dart';
import 'package:firedart/firedart.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomLogInBody extends StatefulWidget {
  const CustomLogInBody({Key? key}) : super(key: key);

  @override
  State<CustomLogInBody> createState() => _CustomLogInBodyState();
}

class _CustomLogInBodyState extends State<CustomLogInBody> {
  bool _isObscure3 = true;
  bool visible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void setRegisterScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }

  void setForgotPasswordScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 5, right: 15, left: 15),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 50,
            ),
            const Text('Bienvenido de nuevo, ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('te hemos extrañado! ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!kIsWeb)
                        if (Platform.isLinux ||
                            Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isFuchsia)
                          IconButton(
                              onPressed: () => emailController.clear(),
                              icon: Icon(Icons.clear, color: Colors.indigo)),
                    ]),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Correo Electrónico',
                hintStyle: TextStyle(
                    color: Colors.indigo, fontWeight: FontWeight.bold),
                enabled: true,
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "El correo electrónico no puede estar vacio.";
                }
                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(value)) {
                  return ("Por favor solicita un correo electrónico válido.");
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                emailController.text = value!;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passwordController,
              obscureText: _isObscure3,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.indigo, fontWeight: FontWeight.bold),
                suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!kIsWeb)
                        if (Platform.isLinux ||
                            Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isFuchsia)
                          IconButton(
                              onPressed: () => passwordController.clear(),
                              icon: Icon(Icons.clear, color: Colors.indigo)),
                      IconButton(
                          color: Colors.indigo,
                          icon: Icon(_isObscure3
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure3 = !_isObscure3;
                            });
                          }),
                    ]),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Contraseña',
                enabled: true,
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                RegExp regex = RegExp(r'^.{6,}$');
                if (value!.isEmpty) {
                  return "La contraseña no puede ser vacía";
                }
                if (!regex.hasMatch(value)) {
                  return "Por favor solicita una contraseña válida Min. 6 carácteres";
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                passwordController.text = value!;
              },
              textCapitalization: TextCapitalization.none,
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(height: 35),
            CustomButton(onTap: () {
              setState(() {
                visible = true;
              });
              signIn();
            }),
            const SizedBox(height: 135),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿No estás registrado?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => setRegisterScreen(context),
                  child: const Text(
                    'Registrate ahora!',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => setForgotPasswordScreen(context),
                  child: const Text(
                    'Toca aquí',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future signIn() async {
    var logger = Logger();
    if (kIsWeb) {
      final _auth = web_auth.FirebaseAuth.instance;
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        await _auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        var user = _auth.currentUser;
        web_firestore.CollectionReference ref =
            web_firestore.FirebaseFirestore.instance.collection('users');
        ref
            .doc(user!.uid)
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.get('rool') == "teacher") {
            setState(() {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const WelcomeProfessorScreen()));
            });
          } else {
            setState(() {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const WelcomeStudentScreen()));
            });
          }
        });
      } catch (e) {
        logger.e(e.toString());
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.indigo,
              title: Center(
                child: Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      }
    } else {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        await firebaseAuth.signIn(
            emailController.text, passwordController.text);
        var user = await firebaseAuth.getUser();
        var ref = Firestore.instance.collection('users').document(user.id);
        if (await ref.exists) {
          var query = await ref.get();
          if (query['rool'] == "teacher") {
            setState(() {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const WelcomeProfessorScreen()));
            });
          } else {
            setState(() {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const WelcomeStudentScreen()));
            });
          }
        }
      } catch (e) {
        logger.e(e.toString());
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.indigo,
              title: Center(
                child: Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      }
    }
  }

  void wrongdBMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.indigo,
          title: Center(
            child: Text(
              'No se encuentra la base de datos',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.indigo,
          title: Center(
            child: Text(
              'Email Incorrecto',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.indigo,
          title: Center(
            child: Text(
              'Contraseña Incorrecta',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
