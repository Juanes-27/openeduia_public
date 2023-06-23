import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firedart/firedart.dart';
import 'package:logger/logger.dart';
import 'package:Openedu.IA/screens/screens.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  _RegisterState();

  bool showProgress = false;
  bool visible = false;

  final _formkey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  var rool = "teacher";

  void setLoginScreen(BuildContext context) {
    Navigator.pop(context,
        MaterialPageRoute(builder: (context) => const LoginRegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(right: 5, left: 5, top: 10, bottom: 10),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "¿Estás listo para",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                  const Text(
                    "esta nueva",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                  const Text(
                    "aventura?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: firstnameController,
                    decoration: InputDecoration(
                      suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!kIsWeb)
                              if (Platform.isLinux ||
                                  Platform.isMacOS ||
                                  Platform.isWindows)
                                IconButton(
                                    onPressed: () =>
                                        firstnameController.clear(),
                                    icon: Icon(Icons.clear,
                                        color: Colors.indigo)),
                          ]),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Nombres',
                      hintStyle: const TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.bold),
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: lastnameController,
                    decoration: InputDecoration(
                      suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!kIsWeb)
                              if (Platform.isLinux ||
                                  Platform.isMacOS ||
                                  Platform.isWindows)
                                IconButton(
                                    onPressed: () => lastnameController.clear(),
                                    icon: Icon(Icons.clear,
                                        color: Colors.indigo)),
                          ]),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Apellidos ',
                      hintStyle: const TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.bold),
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
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
                  const SizedBox(
                    height: 20,
                  ),
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
                                  Platform.isWindows)
                                IconButton(
                                    onPressed: () => emailController.clear(),
                                    icon: Icon(Icons.clear,
                                        color: Colors.indigo)),
                          ]),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Correo Electrónico',
                      hintStyle: const TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.bold),
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "El Correo electrónico no puede ser nulo.";
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return ("Por favor ingresa un correo electrónico válido");
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {},
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: _isObscure,
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!kIsWeb)
                              if (Platform.isLinux ||
                                  Platform.isMacOS ||
                                  Platform.isWindows)
                                IconButton(
                                    onPressed: () => passwordController.clear(),
                                    icon: Icon(Icons.clear,
                                        color: Colors.indigo)),
                            IconButton(
                                color: Colors.indigo,
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                          ]),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Contraseña',
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: _isObscure2,
                    controller: confirmpassController,
                    decoration: InputDecoration(
                      suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!kIsWeb)
                              if (Platform.isLinux ||
                                  Platform.isMacOS ||
                                  Platform.isWindows)
                                IconButton(
                                    onPressed: () =>
                                        confirmpassController.clear(),
                                    icon: Icon(Icons.clear,
                                        color: Colors.indigo)),
                            IconButton(
                                color: Colors.indigo,
                                icon: Icon(_isObscure2
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                }),
                          ]),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Confirma tu Contraseña',
                      hintStyle: const TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.bold),
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.indigo, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.indigo, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (confirmpassController.text !=
                          passwordController.text) {
                        return "Las contraseñas no son iguales !";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ToggleSwitch(
                    minWidth: 150.0,
                    initialLabelIndex: 1,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: const ['Estudiante', 'Profesor'],
                    icons: const [Icons.person, Icons.book],
                    activeBgColors: const [
                      [Colors.indigo],
                      [Colors.indigo]
                    ],
                    onToggle: (index) {
                      if (index == 0) {
                        rool = "student";
                      } else {
                        rool = "teacher";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    elevation: 5.0,
                    height: 50,
                    onPressed: () {
                      setState(() {
                        showProgress = true;
                      });
                      if ((confirmpassController.text ==
                              passwordController.text) &&
                          (lastnameController.text.isNotEmpty) &&
                          (firstnameController.text.isNotEmpty) &&
                          (emailController.text.isNotEmpty)) {
                        if (confirmpassController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          signUp(emailController.text, passwordController.text,
                              rool);
                        }
                      } else {
                        if (confirmpassController.text !=
                            passwordController.text)
                          showInSnackBar('Contraseña no coincide', context);
                        if (confirmpassController.text.isEmpty ||
                            passwordController.text.isNotEmpty)
                          showInSnackBar(
                              'La contraseña no puede estar vacia', context);
                        if (lastnameController.text.isEmpty ||
                            firstnameController.text.isEmpty)
                          showInSnackBar(
                              'Los nombres no pueden estar vacios', context);
                        if (emailController.text.isEmpty)
                          showInSnackBar(
                              'El correo electronico no puede estar vacio',
                              context);
                      }
                    },
                    color: Colors.indigo,
                    child: const Text(
                      "Registrate ",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿Ya estás registrado?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => setLoginScreen(context),
                        child: const Text(
                          ' Ingresa ahora !',
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signUp(String email, String password, String rool) async {
    var logger = Logger();
    if (kIsWeb) {
      CircularProgressIndicator();
      final _auth = web_auth.FirebaseAuth.instance;
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
            (value) => showInSnackBar('Cuenta creada!', context),
          )
          .catchError((e) {
        showInSnackBar('Error creando cuenta ${e}!', context);
      });
      try {
        var user = _auth.currentUser;
        web_firestore.CollectionReference ref =
            web_firestore.FirebaseFirestore.instance.collection('users');
        if (rool == "student") {
          ref.doc(user!.uid).set({
            'email': emailController.text,
            'rool': rool,
            'first_name': firstnameController.text,
            'last_name': lastnameController.text,
            'icon': 'user_00',
            'world_progress': '1',
            'subsection_progress': '0',
            'challenges_count': '0',
          });
        } else {
          ref.doc(user!.uid).set({
            'email': emailController.text,
            'rool': rool,
            'first_name': firstnameController.text,
            'last_name': lastnameController.text,
            'icon': 'user_00',
            'groups_count': '0',
          });
        }
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginRegisterScreen()));
      } catch (e) {
        logger.e(e.toString());
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        wrongRegisterMessage(e.toString());
      }
    } else {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        await firebaseAuth.signUp(email, password).then((value) => {
              showInSnackBar('Cuenta creada!', context),
            });
        var user = await firebaseAuth.getUser();
        CollectionReference ref = Firestore.instance.collection('users');
        if (rool == "student") {
          ref.document(user.id).set({
            'email': emailController.text,
            'rool': rool,
            'first_name': firstnameController.text,
            'last_name': lastnameController.text,
            'icon': 'user_00',
            'world_progress': '1',
            'subsection_progress': '0',
            'challenges_count': '0',
          });
        } else {
          ref.document(user.id).set({
            'email': emailController.text,
            'rool': rool,
            'first_name': firstnameController.text,
            'last_name': lastnameController.text,
            'icon': 'user_00',
            'groups_count': '0',
          });
        }
        // ignore: use_build_context_synchronously
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginRegisterScreen()));
      } catch (e) {
        logger.e(e.toString());
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        wrongRegisterMessage(e.toString());
        // ignore: use_build_context_synchronously
      }
    }
  }

  void wrongRegisterMessage(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo,
          title: Center(
            child: Text(
              error,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
