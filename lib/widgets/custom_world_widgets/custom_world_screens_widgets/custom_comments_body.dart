import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Openedu.IA/constants/constants.dart' as globals;
import 'package:Openedu.IA/widgets/custom_world_widgets/custom_world_widgets.dart';

Future getWorldComments(int world_index) async {
  int world_id = world_index + 1;
  List<String> worldCommentIndex = [];
  List<String> worldCommentContent = [];
  List<String> worldCommentUserIcon = [];
  List<String> worldCommentUserLastName = [];
  List<String> worldCommentUserFistName = [];

  if (kIsWeb) {
    try {
      web_firestore.CollectionReference ref =
          web_firestore.FirebaseFirestore.instance.collection('worlds');
      await ref
          .doc('world_0${world_id}')
          .collection('comments')
          .doc('index')
          .get()
          .then((web_firestore.DocumentSnapshot documentSnapshot) async {
        worldCommentIndex.add(documentSnapshot['count'.toString()]);
        if (documentSnapshot['count'] == '0') {
          worldCommentContent
              .add('No hay comentarios, se el primero en comentar');
        } else {
          if (int.parse(documentSnapshot['count']) <=
              globals.numbershowComments) {
            for (int indexComments = 1;
                indexComments <=
                    int.parse(documentSnapshot['count'].toString());
                indexComments++) {
              web_firestore.CollectionReference comments = web_firestore
                  .FirebaseFirestore.instance
                  .collection('worlds')
                  .doc('world_0${world_id}')
                  .collection('comments');
              await comments
                  .doc('comment_${indexComments}')
                  .get()
                  .then((web_firestore.DocumentSnapshot documentSnapshot) {
                worldCommentContent.add(documentSnapshot['content']);
                worldCommentUserIcon.add(documentSnapshot['icon']);
                worldCommentUserLastName.add(documentSnapshot['user_lastname']);
                worldCommentUserFistName.add(documentSnapshot['user_name']);
              });
            }
          } else {
            for (int indexComments =
                    int.parse(documentSnapshot['count'].toString()) -
                        globals.numbershowComments;
                indexComments <=
                    int.parse(documentSnapshot['count'].toString());
                indexComments++) {
              web_firestore.CollectionReference comments = web_firestore
                  .FirebaseFirestore.instance
                  .collection('worlds')
                  .doc('world_0${world_id}')
                  .collection('comments');
              await comments
                  .doc('comment_${indexComments}')
                  .get()
                  .then((web_firestore.DocumentSnapshot documentSnapshot) {
                worldCommentContent.add(documentSnapshot['content']);
                worldCommentUserIcon.add(documentSnapshot['icon']);
                worldCommentUserLastName.add(documentSnapshot['user_lastname']);
                worldCommentUserFistName.add(documentSnapshot['user_name']);
              });
            }
          }
        }
      });
    } catch (e) {
      worldCommentIndex.add('0');
      worldCommentContent.add(
          'Error realizando la petición para obtener los comentarios intenta más tarde');
      worldCommentUserIcon.add('user_fail');
      worldCommentUserFistName.add('Error');
      worldCommentUserLastName.add(e.toString());
    }
    return [
      worldCommentIndex,
      worldCommentContent,
      worldCommentUserIcon,
      worldCommentUserFistName,
      worldCommentUserLastName
    ];
  } else {
    try {
      var ref = Firestore.instance
          .collection('worlds')
          .document('world_0${world_id}')
          .collection('comments')
          .document('index');
      var query = await ref.get();
      worldCommentIndex.add(query['count']);
      if (query['count'].toString() == '0') {
        worldCommentContent
            .add('No hay comentarios, se el primero en comentar');
      } else {
        if (int.parse(query['count']) <= globals.numbershowComments) {
          for (int indexComments = 1;
              indexComments <= int.parse(query['count']);
              indexComments++) {
            var comments = Firestore.instance
                .collection('worlds')
                .document('world_0${world_id}')
                .collection('comments')
                .document('comment_${indexComments}');
            var getComments = await comments.get();
            worldCommentContent.add(getComments['content']);
            worldCommentUserIcon.add(getComments['icon']);
            worldCommentUserFistName.add(getComments['user_name']);
            worldCommentUserLastName.add(getComments['user_lastname']);
          }
        } else {
          for (int indexComments =
                  int.parse(query['count']) - globals.numbershowComments;
              indexComments <= int.parse(query['count']);
              indexComments++) {
            var comments = Firestore.instance
                .collection('worlds')
                .document('world_0${world_id}')
                .collection('comments')
                .document('comment_${indexComments}');
            var getComments = await comments.get();
            worldCommentContent.add(getComments['content']);
            worldCommentUserIcon.add(getComments['icon']);
            worldCommentUserFistName.add(getComments['user_name']);
            worldCommentUserLastName.add(getComments['user_lastname']);
          }
        }
      }
    } catch (e) {
      worldCommentContent.add(
          'Error realizando la petición para obtener los comentarios intenta más tarde');
      worldCommentUserIcon.add('user_fail');
      worldCommentUserFistName.add('Error');
      worldCommentUserLastName.add(e.toString());
    }
    return [
      worldCommentIndex,
      worldCommentContent,
      worldCommentUserIcon,
      worldCommentUserFistName,
      worldCommentUserLastName
    ];
  }
}

class CommentsWorldScreen extends StatelessWidget {
  final int world_index;
  CommentsWorldScreen({Key? key, required this.world_index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _numberCards = 0;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FutureBuilder(
              future: getWorldComments(world_index),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (snapshot.data[0][0] != '0') {
                      if (int.parse(snapshot.data[0][0]) <=
                          globals.numbershowComments) {
                        _numberCards = int.parse(snapshot.data[0][0]);
                      } else {
                        _numberCards = globals.numbershowComments;
                      }
                      return ListView.separated(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        snapshot.data[3][index] +
                                            " " +
                                            snapshot.data[4][index],
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: globals.pinkColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: FadeInImage(
                                            image: AssetImage(
                                                'assets/images/user/${snapshot.data[2][index]}.png'),
                                            placeholder: AssetImage(
                                                'assets/icon/loading.gif'),
                                          )),
                                      subtitle: Text(
                                        snapshot.data[1][index],
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          separatorBuilder: (BuildContext _, int __) =>
                              const Divider(),
                          itemCount: _numberCards);
                    } else {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          'No hay comentarios sobre este mundo, se el primero en comentar',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      );
                    }
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Error obteniendo los comentarios... verifica tu conexión a internet o intentanlo más tarde.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    );
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
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => CustomAddCommentDialog(
                            world_index: this.world_index,
                          ));
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.purpleAccent.shade100,
                foregroundColor: Colors.white),
          )
        ],
      ),
    );
  }
}
