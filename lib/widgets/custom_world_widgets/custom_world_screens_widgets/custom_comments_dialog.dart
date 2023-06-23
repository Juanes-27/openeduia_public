import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../screens/worlds/worlds.dart';

Future addComment(String contentComment, int world_index) async {
  int world_id = world_index + 1;
  int count_comments = 0;
  List<String> userIcon = [];
  List<String> user_lastname = [];
  List<String> user_name = [];
  String world_name = "";
  try {
    if (kIsWeb) {
      try {
        final _auth = web_auth.FirebaseAuth.instance;
        var user = await _auth.currentUser;
        web_firestore.CollectionReference ref =
            web_firestore.FirebaseFirestore.instance.collection('users');
        await ref
            .doc(user!.uid)
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) async {
          userIcon.add(documentSnapshot['icon'].toString());
          user_lastname.add(documentSnapshot['last_name'].toString());
          user_name.add(documentSnapshot['first_name'].toString());
        });
        web_firestore.CollectionReference comment =
            web_firestore.FirebaseFirestore.instance.collection('worlds');
        await comment
            .doc('world_0${world_id}')
            .collection('comments')
            .doc('index')
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) async {
          count_comments = int.parse(documentSnapshot['count']) + 1;
        });
        await comment
            .doc('world_0${world_id}')
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) async {
          world_name = ((documentSnapshot['name']).toString());
        });
        await comment
            .doc('world_0${world_id}')
            .collection('comments')
            .doc('index')
            .update({'count': count_comments.toString()});
        await comment
            .doc('world_0${world_id}')
            .collection('comments')
            .doc('comment_${count_comments}')
            .set({
          "content": contentComment.toString(),
          "icon": userIcon[0].toString(),
          "id": user.uid.toString(),
          "user_lastname": user_lastname[0].toString(),
          "user_name": user_name[0].toString(),
        });
      } catch (e) {
        userIcon.add('user_00');
        user_lastname.add('Error Lastname');
        user_name.add('Error FirstName');
        print(e);
      }
      return world_name;
    } else {
      try {
        final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        var user = await firebaseAuth.getUser();
        var ref = Firestore.instance.collection('users').document(user.id);
        var userInfo = await ref.get();
        userIcon.add(userInfo['icon'].toString());
        user_lastname.add(userInfo['last_name'].toString());
        user_name.add(userInfo['first_name'].toString());
        var worldName = Firestore.instance
            .collection('worlds')
            .document('world_0${world_id}');
        var getWorldName = await worldName.get();
        world_name = (getWorldName['name'].toString());
        var comment = Firestore.instance
            .collection('worlds')
            .document('world_0${world_id}')
            .collection('comments');
        var indexComment = await comment.document('index').get();
        count_comments = int.parse(indexComment['count'].toString()) + 1;
        await comment.document('index').update({'count': '${count_comments}'});
        await comment.document('comment_${count_comments}').set({
          "content": contentComment.toString(),
          "icon": userIcon[0].toString(),
          "id": user.id.toString(),
          "user_lastname": user_lastname[0].toString(),
          "user_name": user_name[0].toString(),
        });
      } catch (e) {
        userIcon.add('user_00');
        user_lastname.add('Error Lastname');
        user_name.add('Error FirstName');
        print(e);
      }
      return world_name;
    }
  } catch (e) {
    print(e);
  }
}

class CustomAddCommentDialog extends StatelessWidget {
  final int world_index;
  CustomAddCommentDialog({Key? key, required this.world_index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(10),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo,
                  blurRadius: 10.0,
                )
              ],
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Agrega un Comentario!',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.purpleAccent.shade100,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: 'Contenido del comentario',
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
                      return null;
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {},
                  keyboardType: TextInputType.multiline,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      right: 10,
                    ),
                    child: SizedBox(
                      width: 100,
                      child: MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        elevation: 5.0,
                        height: 50,
                        color: Colors.indigo,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancelar',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      right: 10,
                    ),
                    child: SizedBox(
                      width: 100,
                      child: MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        elevation: 5.0,
                        height: 50,
                        color: Colors.indigo,
                        onPressed: () async {
                          String worldName = "";

                          worldName = await addComment(
                              messageController.text, this.world_index);
                          CircularProgressIndicator();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      WorldsSubsectionsScreen(
                                        world_index: this.world_index,
                                        world_name: worldName.toString(),
                                      )));
                        },
                        child: Text(
                          'Agregar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ])),
      ),
    );
  }
}
