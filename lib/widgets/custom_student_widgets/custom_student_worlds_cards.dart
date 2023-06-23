import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:Openedu.IA/screens/worlds/worlds.dart';
import 'package:Openedu.IA/constants/constants.dart' as globals;
import 'package:quickalert/quickalert.dart';

List<String> getWorldsImage() {
  List<String> worldsImages = [];

  for (int i = 1; i <= globals.numberWorlds; i++) {
    worldsImages.add('assets/worlds/worlds_cards_icons/world_0${i}.jpg');
  }
  return worldsImages;
}

Future getWorldsName() async {
  List<String> worldsNames = [];
  String world_progress = "1";
  if (kIsWeb) {
    final _auth = web_auth.FirebaseAuth.instance;
    var user = await _auth.currentUser;
    web_firestore.CollectionReference user_ref =
        web_firestore.FirebaseFirestore.instance.collection('users');
    await user_ref
        .doc(user!.uid)
        .get()
        .then((web_firestore.DocumentSnapshot documentSnapshot) {
      world_progress = documentSnapshot['world_progress'].toString();
    });
    for (int i = 1; i <= globals.numberWorlds; i++) {
      try {
        web_firestore.CollectionReference ref =
            web_firestore.FirebaseFirestore.instance.collection('worlds');
        await ref
            .doc('world_0${i}')
            .get()
            .then((web_firestore.DocumentSnapshot documentSnapshot) {
          worldsNames.add(documentSnapshot['name'].toString());
        });
      } catch (e) {
        worldsNames.add('Error!');
        world_progress = "1";
      }
    }
    return [worldsNames, world_progress];
  } else {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = await firebaseAuth.getUser();
    var user_ref = Firestore.instance.collection('users').document(user.id);
    var user_query = await user_ref.get();
    world_progress = user_query['world_progress'];
    for (int i = 1; i <= globals.numberWorlds; i++) {
      try {
        var ref =
            Firestore.instance.collection('worlds').document('world_0${i}');
        var query = await ref.get();
        worldsNames.add(query['name']);
      } catch (e) {
        worldsNames.add('Error!');
        world_progress = "1";
      }
    }
    return [worldsNames, world_progress];
  }
}

class WorldsCardSwiper extends StatefulWidget {
  const WorldsCardSwiper({Key? key}) : super(key: key);

  @override
  State<WorldsCardSwiper> createState() => _WorldsCardSwiperState();
}

class _WorldsCardSwiperState extends State<WorldsCardSwiper> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> worldsImages = getWorldsImage();
    return FutureBuilder(
        future: getWorldsName(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: width,
              height: height,
              child: Swiper(
                itemCount: globals.numberWorlds,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          snapshot.data[0][index].toString(),
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(height: 15),
                        if (kIsWeb)
                          GestureDetector(
                            onTap: () {
                              setState(() {});
                              if (index + 1 <= int.parse(snapshot.data[1]) ||
                                  index == 6)
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        WorldsSubsectionsScreen(
                                          world_index: index,
                                          world_name: snapshot.data[0][index]
                                              .toString(),
                                        )));
                              if (index + 1 > int.parse(snapshot.data[1]) &&
                                  index != 6)
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.info,
                                    title: "Información",
                                    titleColor: Colors.indigo,
                                    textColor: Colors.black,
                                    text:
                                        'Tienes que completar el mundo anterior',
                                    confirmBtnText: 'Aceptar');
                            },
                            child: Container(
                              width: width,
                              height: 280,
                              child: FadeInImage(
                                image:
                                    AssetImage(worldsImages[index].toString()),
                                placeholder: const AssetImage(
                                  'assets/icon/loading.gif',
                                ),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        if (!kIsWeb)
                          if (Platform.isAndroid || Platform.isIOS)
                            GestureDetector(
                              onTap: () {
                                setState(() {});
                                if (index + 1 <= int.parse(snapshot.data[1]) ||
                                    index == 6)
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          WorldsSubsectionsScreen(
                                            world_index: index,
                                            world_name: snapshot.data[0][index]
                                                .toString(),
                                          )));
                                if (index + 1 > int.parse(snapshot.data[1]) &&
                                    index != 6)
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.info,
                                      title: "Información",
                                      titleColor: Colors.indigo,
                                      textColor: Colors.black,
                                      text:
                                          'Tienes que completar el mundo anterior',
                                      confirmBtnText: 'Aceptar');
                              },
                              child: Container(
                                width: width,
                                height: 300,
                                child: FadeInImage(
                                  image: AssetImage(
                                      worldsImages[index].toString()),
                                  placeholder: const AssetImage(
                                    'assets/icon/loading.gif',
                                  ),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                        if (!kIsWeb)
                          if (Platform.isFuchsia ||
                              Platform.isMacOS ||
                              Platform.isWindows ||
                              Platform.isLinux)
                            GestureDetector(
                              onTap: () {
                                setState(() {});
                                if (index + 1 <= int.parse(snapshot.data[1]) ||
                                    index == 6)
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          WorldsSubsectionsScreen(
                                            world_index: index,
                                            world_name: snapshot.data[0][index]
                                                .toString(),
                                          )));
                                if (index + 1 > int.parse(snapshot.data[1]) &&
                                    index != 6)
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.info,
                                      title: "Información",
                                      titleColor: Colors.indigo,
                                      textColor: Colors.black,
                                      text:
                                          'Tienes que completar el mundo anterior',
                                      confirmBtnText: 'Aceptar');
                              },
                              child: Container(
                                width: width,
                                height: 300,
                                child: FadeInImage(
                                  image: AssetImage(
                                      worldsImages[index].toString()),
                                  placeholder: const AssetImage(
                                    'assets/icon/loading.gif',
                                  ),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                      ],
                    ),
                  );
                },
                indicatorLayout: PageIndicatorLayout.COLOR,
                autoplay: false,
                pagination: const SwiperPagination(),
                control: const SwiperControl(),
              ),
            );
          } else {
            return Center(
                child: Text(
              'Cargando ...',
              style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ));
          }
        });
  }
}
