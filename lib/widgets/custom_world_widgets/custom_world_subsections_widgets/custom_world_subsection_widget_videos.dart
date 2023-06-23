import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Openedu.IA/constants/constants.dart' as globals;

Future getVideosList(
    int world_index, int subsection_index, BuildContext context) async {
  int world_id = world_index + 1;
  subsection_index += 1;
  List<String> videosIds = [];
  List<String> videosName = [];
  String videos_count = "0";

  if (kIsWeb) {
    web_firestore.CollectionReference ref =
        web_firestore.FirebaseFirestore.instance.collection('worlds');
    await ref
        .doc('world_0${world_id}')
        .collection('subsections')
        .doc('subsection_0${subsection_index}')
        .get()
        .then((web_firestore.DocumentSnapshot documentSnapshot) {
      videos_count = documentSnapshot['videos_count'];
    });

    for (int videos_index = 1;
        videos_index <= int.parse(videos_count);
        videos_index++) {
      try {
        web_firestore.CollectionReference ref =
            web_firestore.FirebaseFirestore.instance.collection('worlds');
        await ref
            .doc('world_0${world_id}')
            .collection('subsections')
            .doc('subsection_0${subsection_index + 1}')
            .collection('videos')
            .doc('video_0${videos_index}')
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) {
          videosIds.add(documentSnapshot['videoUrl']);
          videosName.add(documentSnapshot['name']);
        });
      } catch (e) {
        showInSnackBar('Error-> ${e}', context);
      }
    }

    return [videos_count, videosIds, videosName];
  } else {
    var ref = Firestore.instance
        .collection('worlds')
        .document('world_0${world_id}')
        .collection('subsections')
        .document('subsection_0${subsection_index}');
    var query = await ref.get();
    videos_count = query['videos_count'].toString();
    for (int videos_index = 1;
        videos_index <= int.parse(videos_count);
        videos_index++) {
      try {
        var ref = Firestore.instance
            .collection('worlds')
            .document('world_0${world_id}')
            .collection('subsections')
            .document('subsection_0${subsection_index}')
            .collection('videos')
            .document('video_0${videos_index}');
        var query = await ref.get();
        videosIds.add(query['videoUrl'].toString());
        videosName.add(query['name'].toString());
      } catch (e) {
        showInSnackBar('Error-> ${e}', context);
      }
    }

    return [videos_count, videosIds, videosName];
  }
}

class CustomWorldSubsectionWidgetVideos extends StatelessWidget {
  final String world_index;
  final String subsection_index;
  const CustomWorldSubsectionWidgetVideos(
      {Key? key, required this.world_index, required this.subsection_index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: getVideosList(int.parse(this.world_index),
                int.parse(this.subsection_index), context),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: int.parse(snapshot.data[0]),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      if (kIsWeb) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CustomWorldSubsectionShowVideo(
                                  videoName: snapshot.data[2][index],
                                  videoURL: snapshot.data[1][index],
                                )));
                      }
                      if (!kIsWeb) {
                        if (Platform.isAndroid || Platform.isIOS) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CustomWorldSubsectionShowVideo(
                                    videoName: snapshot.data[2][index],
                                    videoURL: snapshot.data[1][index],
                                  )));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CustomWorldSubsectionDontShowVideo(
                                    videoName: snapshot.data[2][index],
                                    videoURL: snapshot.data[1][index],
                                  )));
                        }
                      }
                    },
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              snapshot.data[2][index],
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
                                placeholder:
                                    AssetImage('assets/icon/loading.gif'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (BuildContext _, int __) => const Divider(),
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
            })
      ],
    );
  }
}
