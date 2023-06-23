import 'package:flutter/material.dart';
import 'dart:ui';

class CustomWelcomeProfessorBackground extends StatelessWidget {
  const CustomWelcomeProfessorBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    var pixelRatio = window.devicePixelRatio;
    // ignore: deprecated_member_use
    var logicalScreenSize = window.physicalSize / pixelRatio;
    var logicalWidth = logicalScreenSize.width;
    var logicalHeight = logicalScreenSize.height;
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
                      "assets/images/welcome/learning_professor.jpg",
                      width: logicalWidth - 100,
                      height: logicalHeight,
                    ))
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
