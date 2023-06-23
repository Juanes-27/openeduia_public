import 'package:flutter/material.dart';
import '../../screens/screens.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomWelcomeProfessorBody extends StatelessWidget {
  const CustomWelcomeProfessorBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (kIsWeb)
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: screenHeight / 2 + 80, right: 15, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Acompaña a tus",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Estudiantes !",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Te facilitamos la \n tarea de enseñar IA \n a tus estudiantes ! ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.indigo,
                  wordSpacing: 2.5,
                  height: 1.5,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    height: 60,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    color: Colors.pink,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeProfessorScreen()));
                    },
                    child: const Text(
                      "Continua",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    else
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: screenHeight / 2 + 80, right: 15, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Acompaña a tus",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Estudiantes !",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Te facilitamos la \n tarea de enseñar IA \n a tus estudiantes ! ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.indigo,
                  wordSpacing: 2.5,
                  height: 1.5,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    height: 60,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    color: Colors.pink,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeProfessorScreen()));
                    },
                    child: const Text(
                      "Continua",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
  }
}
