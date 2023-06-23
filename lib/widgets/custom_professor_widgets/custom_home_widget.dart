import 'package:Openedu.IA/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:Openedu.IA/constants/constants.dart' as globals;
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomActiveGroupWidget extends StatefulWidget {
  const CustomActiveGroupWidget({Key? key}) : super(key: key);

  @override
  State<CustomActiveGroupWidget> createState() =>
      _CustomActiveGroupWidgetState();
}

class _CustomActiveGroupWidgetState extends State<CustomActiveGroupWidget> {
  Future getGroupsInfo(BuildContext context) async {
    String groups_count = "0";
    List<String> groups_names = [];
    List<String> groups_active_students = [];
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
          groups_count = documentSnapshot['groups_count'].toString();
        });
        if (int.parse(groups_count) != 0) {
          for (int i = 1; i <= int.parse(groups_count); i++) {
            await ref
                .doc(user.uid)
                .collection('students_groups')
                .doc('group_${i}')
                .get()
                .then((web_firestore.DocumentSnapshot documentSnapshot) {
              groups_names.add(documentSnapshot['name']);
              groups_active_students.add(documentSnapshot['students_count']);
            });
          }
        }
      } catch (e) {
        showInSnackBar('Error-> ${e}', context);
      }
      return [groups_count, groups_names, groups_active_students];
    } else {
      try {
        final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        var user = await firebaseAuth.getUser();
        var ref = Firestore.instance.collection('users').document(user.id);
        var query = await ref.get();
        groups_count = query['groups_count'].toString();
        if (int.parse(groups_count) != 0) {
          for (int i = 1; i <= int.parse(groups_count); i++) {
            var student_groups =
                ref.collection('students_groups').document('group_${i}');
            var student_query = await student_groups.get();
            groups_names.add(student_query['name']);
            groups_active_students.add(student_query['students_count']);
          }
        }
      } catch (e) {
        showInSnackBar('Error-> ${e}', context);
      }
      return [groups_count, groups_names, groups_active_students];
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SizedBox(
          width: size.width,
          height: size.height,
          child: FutureBuilder(
              future: getGroupsInfo(context),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (int.parse(snapshot.data[0]) == 0)
                          Text('No tienes ningún grupo creado.')
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Grupos Creados",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeProfessorScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), // Adjust the radius as needed
                                  ),
                                ),
                                child: Icon(
                                  Icons.refresh_sharp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        if (int.parse(snapshot.data[0]) != 0)
                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: int.parse(snapshot.data[0]),
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomGroupInfoBody(
                                                groupName: snapshot.data[1]
                                                        [index]
                                                    .toString(),
                                                studentsCount: snapshot.data[2]
                                                        [index]
                                                    .toString(),
                                                groupIndex: index.toString())));
                              },
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: FadeInImage(
                                          image: AssetImage(
                                              'assets/worlds/worlds_subsections_icons/${globals.subsectionsIcons[index]}'),
                                          placeholder: AssetImage(
                                              'assets/icon/loading.gif'),
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Hay ${snapshot.data[2][index]} estudiante/s activos dentro de este grupo.",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      title: Text(
                                        snapshot.data[1][index],
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: globals.pinkColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            separatorBuilder: (BuildContext _, int __) =>
                                const Divider(),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Crear Grupo',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomProfessorAddGroupsScreen()))
                              },
                              child: const Text(
                                'Toca aquí',
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]);
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: size.height / 4,
                      ),
                      Text(
                        'Cargando ...',
                        style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontSize: 36),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        color: Colors.indigo,
                      )
                    ],
                  );
                }
              })),
    );
  }
}
