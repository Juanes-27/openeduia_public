import 'package:flutter/material.dart';
import 'package:Openedu.IA/screens/screens.dart';
import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as web_firestore;
import 'package:firebase_auth/firebase_auth.dart' as web_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Openedu.IA/constants/constants.dart' as globals;

Future getName() async {
  if (kIsWeb) {
    String user_icon = '';
    String user_rool = '';
    String fullName = '';
    try {
      final _auth = web_auth.FirebaseAuth.instance;
      var user = await _auth.currentUser;
      web_firestore.CollectionReference ref =
          web_firestore.FirebaseFirestore.instance.collection('users');
      await ref
          .doc(user!.uid)
          .get()
          .then((web_firestore.DocumentSnapshot documentSnapshot) {
        fullName = documentSnapshot['first_name'].toString() +
            ' ' +
            documentSnapshot['last_name'].toString();
        user_icon = documentSnapshot['icon'].toString();
        user_rool = documentSnapshot['rool'].toString();
      });
      return [fullName, user_icon, user_rool];
    } catch (e) {
      print("Eror!");
      return "Error";
    }
  } else {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.getUser();
      var ref = Firestore.instance.collection('users').document(user.id);
      var query = await ref.get();
      String name = query['first_name'] + ' ' + query['last_name'];
      return [name, query['icon'], query['rool']];
    } catch (e) {
      return "Error";
    }
  }
}

class CustomStudentAppBarHome extends StatefulWidget {
  final int? selected_avatar;

  const CustomStudentAppBarHome({Key? key, this.selected_avatar})
      : super(key: key);
  @override
  State<CustomStudentAppBarHome> createState() =>
      _CustomStudentAppBarHomeState();
}

class _CustomStudentAppBarHomeState extends State<CustomStudentAppBarHome> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: getName(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return CustomPaint(
                painter: LogoPainter(),
                size: Size(size.width, 195),
                child: _appBarContent(context, snapshot.data[0],
                    snapshot.data[1], snapshot.data[2]));
          } else {
            return Container(
              height: 110,
              width: size.width,
              child: CustomPaint(
                painter: LogoPainter(),
                size: Size(size.width, 138),
              ),
            );
          }
        });
  }
}

Widget _appBarContent(
    BuildContext context, String name, String avatar, String rool) {
  final size = MediaQuery.of(context).size;

  return Container(
    height: 110,
    width: size.width,
    margin: const EdgeInsets.only(right: 10, top: 20, left: 10, bottom: 5),
    child: Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        _userInfo(context, name, avatar, rool),
      ],
    ),
  );
}

Widget _userInfo(
    BuildContext context, String name, String avatar, String rool) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _userAvatar(context, avatar, rool),
      const SizedBox(
        width: 20,
      ),
      Expanded(
        flex: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _userPersonalInfo(context, name, rool),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _userAvatar(BuildContext context, String avatar, String rool) {
  return CircleAvatar(
      radius: 35,
      backgroundImage:
          AssetImage('assets/images/user/${avatar.toString()}.png'),
      child: GestureDetector(
          onTap: () => showDialog(
              context: context,
              builder: (context) => CustomIconDialog(
                    rool: rool,
                  ))));
}

Widget _userPersonalInfo(BuildContext context, String name, String rool) {
  String user_rool = '';
  IconData user_icon;
  void signUserOut() {
    if (kIsWeb) {
      final _auth = web_auth.FirebaseAuth.instance;
      _auth.signOut();
    } else {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      firebaseAuth.signOut();
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginRegisterScreen()),
        (route) => false);
  }

  if (rool == 'student') {
    user_rool = 'Estudiante de IA';
    user_icon = Icons.school_rounded;
  } else {
    user_rool = 'Profesor';
    user_icon = Icons.diversity_3_rounded;
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  user_icon,
                  color: Colors.white,
                  size: 15,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  user_rool,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 10, letterSpacing: 2, color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
      Column(
        children: [
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmación de salida '),
                        titleTextStyle: TextStyle(
                            color: globals.pinkColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                        content: Text(
                          '¿Estás seguro/a de que quieres salir? ',
                          textAlign: TextAlign.justify,
                        ),
                        contentTextStyle: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        actions: [
                          MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('NO',
                                  style: TextStyle(
                                      color: globals.pinkColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                          MaterialButton(
                              onPressed: () {
                                signUserOut();
                              },
                              child: Text('SI',
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)))
                        ],
                      );
                    });
              },
              child: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => StudentAppBarConfigScreen()));
              },
              child: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      )
    ],
  );
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint = Paint();
    Path path = Path();
    paint.shader = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.indigo, Colors.indigo],
    ).createShader(rect);
    path.lineTo(0, size.height - size.height / 8);
    path.conicTo(size.width / 1.2, size.height, size.width,
        size.height - size.height / 8, 9);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawShadow(path, globals.pinkColor, 4, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
