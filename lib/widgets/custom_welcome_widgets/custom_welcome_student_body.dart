import 'package:flutter/material.dart';
import 'package:Openedu.IA/screens/screens.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomWelcomeStudentBody extends StatelessWidget {
  const CustomWelcomeStudentBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (kIsWeb)
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: (size.height / 2) + 80, right: 15, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Aprende acerca de",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Inteligencia Artificial",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Te ayudaremos a explorar \n este maravilloso mundo, \n estamos contigo ! ",
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
                    height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    color: Colors.pink,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeStudentScreen();
                      }));
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
              top: (size.height / 2) + 80, right: 15, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Aprende acerca de",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Inteligencia Artificial",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Te ayudaremos a explorar \n este maravilloso mundo, \n estamos contigo ! ",
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
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    color: Colors.pink,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeStudentScreen();
                      }));
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
