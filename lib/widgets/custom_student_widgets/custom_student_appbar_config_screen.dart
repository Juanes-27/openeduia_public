import 'package:flutter/material.dart';
import 'package:Openedu.IA/constants/constants.dart' as globals;
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firedart/firedart.dart';

Future getConfigInfo(BuildContext context) async {
  String getRoolUser = "";
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
        getRoolUser = documentSnapshot['rool'].toString();
      });
    } catch (e) {
      getRoolUser = "Error";
      showInSnackBar('Error Cargando Configuración: ${e}', context);
    }
  } else {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      var ref = Firestore.instance.collection('users').document(user.id);
      var query = await ref.get();
      getRoolUser = query['rool'].toString();
    } catch (e) {
      getRoolUser = "Error";
      showInSnackBar('Error Cargando Configuración: ${e}', context);
    }
  }
  return getRoolUser;
}

class StudentAppBarConfigScreen extends StatelessWidget {
  const StudentAppBarConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    List<String> nameConfigs = [
      "Cambia tu Contraseña",
      //"Cambiar el Tipo de Cuenta",
      "Elimina tu Cuenta",
      "Agrega tu Cuenta a un Grupo de Estudio",
    ];
    List<Widget> configScreens = [
      ConfigPasswordChangeScreen(),
      //ConfigAccountChangeScreen(),
      ConfigDeleteAccountScreen(),
      ConfigAddAccountGroupScreen()
    ];
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Configuración",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: getConfigInfo(context),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.toString() == "student") {
                  return SizedBox(
                      height: screenHeight - 100,
                      width: screenWidth,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              configScreens[index]));
                                },
                                child: Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        subtitle: Text(
                                          "${nameConfigs[index]}",
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: FadeInImage(
                                            image: AssetImage(
                                                'assets/worlds/worlds_subsections_icons/${globals.subsectionsIcons[index]}'),
                                            placeholder: AssetImage(
                                                'assets/icon/loading.gif'),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          itemCount: nameConfigs.length));
                } else {
                  return SizedBox(
                      height: screenHeight - 100,
                      width: screenWidth,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              configScreens[index]));
                                },
                                child: Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        subtitle: Text(
                                          "${nameConfigs[index]}",
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: FadeInImage(
                                            image: AssetImage(
                                                'assets/worlds/worlds_subsections_icons/${globals.subsectionsIcons[index]}'),
                                            placeholder: AssetImage(
                                                'assets/icon/loading.gif'),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          itemCount: nameConfigs.length - 1));
                }
              } else {
                return Center(
                    child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Cargando ...',
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator(
                      color: Colors.indigo,
                    )
                  ],
                ));
              }
            }),
      ),
    );
  }
}
