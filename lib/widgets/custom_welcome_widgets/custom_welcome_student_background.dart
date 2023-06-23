import 'package:flutter/material.dart';

class CustomWelcomeStudentBackground extends StatelessWidget {
  const CustomWelcomeStudentBackground({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(177, 201, 232, 1),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(50))),
                child: Column(
                  children: [
                    Expanded(
                        child: Image.asset(
                            "assets/images/welcome/learning_students.jpg"))
                  ],
                ),
              )),
          Expanded(
              flex: 2,
              child: Container(
                color: const Color.fromRGBO(177, 201, 232, 1),
                child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                        )),
                    child: null),
              ))
        ],
      ),
    );
  }
}
