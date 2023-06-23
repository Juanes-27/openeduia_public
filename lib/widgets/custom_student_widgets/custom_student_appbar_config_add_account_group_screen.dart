import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/services.dart';

Future getUserId(BuildContext context) async {
  String userId = "Error obteniendo Id";
  if (kIsWeb) {
    try {
      final _auth = web_auth.FirebaseAuth.instance;
      var user = await _auth.currentUser;

      userId = user!.uid;
    } catch (e) {
      showInSnackBar('Error-> ${e}', context);
    }
  } else {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      userId = user.id;
    } catch (e) {
      showInSnackBar('Error-> ${e}', context);
    }
  }
  return [userId];
}

class ConfigAddAccountGroupScreen extends StatelessWidget {
  const ConfigAddAccountGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agrega tu Cuenta a un Grupo de Estudio"),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: getUserId(context),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          "En este apartado encontrarás tu ID de usuario que es necesario para que tu profesor te asignarte dentro de un grupo de estudio y mirar tu progreso.",
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
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: TextField(
                            readOnly: true,
                            controller:
                                TextEditingController(text: snapshot.data[0])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: snapshot.data[0]));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Texto copiado')),
                            );
                          },
                          child: Icon(Icons.copy)),
                    ],
                  );
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
        ],
      ),
    );
  }
}
